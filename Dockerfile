FROM debian:8.11-slim

# install dependencies 
RUN apt update \
		&& apt install gcc g++ flex libz-dev libboost-all-dev libgmp-dev libmpfr-dev --force-yes -y \
		&& apt install libbison-dev openmpi-bin libopenmpi-dev cmake git wget --force-yes -y

# define arguments and add an alias to source the OpenFOAM bashrc
ARG VERSION="2.4.x"
ARG TARGET_DIR="/opt/openfoam/${VERSION}"
RUN echo "alias foamInit='source $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc'" >> $HOME/.bashrc

# compile OpenFOAM without ParaView and CGAL
WORKDIR ${TARGET_DIR}
RUN git clone https://github.com/OpenFOAM/OpenFOAM-2.4.x.git \
		&& wget http://download.sourceforge.net/project/foam/foam/2.4.0/ThirdParty-2.4.0.tgz \
		&& tar zxvf ThirdParty-2.4.0.tgz --exclude=ParaView* --exclude=openmpi* --exclude=cmake* --exclude=CGAL*\
		&& rm ThirdParty-2.4.0.tgz && mv ThirdParty-2.4.0 ThirdParty-${VERSION} \
		&& wget https://www2.hs-esslingen.de/~asaramet/packages/metis-5.1.0.tar.gz \
		#&& wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz \
		&& tar zxvf metis-5.1.0.tar.gz -C ${TARGET_DIR}/ThirdParty-${VERSION} && rm metis-5.1.0.tar.gz \
		&& wget https://github.com/CGAL/cgal/archive/refs/tags/releases/CGAL-4.6.3.tar.gz \
		&& tar zxvf CGAL-4.6.3.tar.gz && rm CGAL-4.6.3.tar.gz \
		&& mv cgal-releases-CGAL-4.6.3/ ThirdParty-${VERSION}/CGAL-4.6

WORKDIR $TARGET_DIR/OpenFOAM-${VERSION}
RUN sed -i s:'foamInstall=$HOME/$WM_PROJECT':"foamInstall=$TARGET_DIR":g etc/bashrc 

RUN bash -c "source $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc \
		&& ./Allwmake 2>&1 | tee Allwmake.log \
		&& ./Allwmake 2>&1 | tee Allwmake.log"

# Install swak4Foam
RUN git clone https://github.com/Unofficial-Extend-Project-Mirror/openfoam-extend-Breeder2.0-libraries-swak4Foam.git ${TARGET_DIR}/swak4Foam
WORKDIR ${TARGET_DIR}/swak4Foam

RUN echo 'SWAK4FOAM_SRC="/opt/bwhpc/common/cae/openfoam/${VERSION}/swak4Foam/Libraries"' >> ${TARGET_DIR}/OpenFOAM-${VERSION}/etc/bashrc \
		&& echo 'PATH="/opt/bwhpc/common/cae/openfoam/${VERSION}/swak4Foam/privateRequirements/bin":$PATH' >> ${TARGET_DIR}/OpenFOAM-${VERSION}/etc/bashrc

## Install bison-2
RUN bash -c "source $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc \
		&& ./maintainanceScripts/compileRequirements.sh"

## Compile swak4Foam
RUN	bash -c "source $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc \
		&& cp swakConfiguration.debian swakConfiguration \
		&& export WM_NCOMPPROCS=4 \
		&& ./Allwmake -j 4 \
		&& ./Allwmake -j 4 \
		&& ./maintainanceScripts/copySwakFilesToSite.sh"

## Move data to global install
RUN mv /root/OpenFOAM/-2.4.x/platforms/linux64GccDPOpt/lib/* /opt/openfoam/2.4.x/OpenFOAM-2.4.x/platforms/linux64GccDPOpt/lib -v \
		&& mv /root/OpenFOAM/-2.4.x/platforms/linux64GccDPOpt/bin/* /opt/openfoam/2.4.x/OpenFOAM-2.4.x/platforms/linux64GccDPOpt/bin -v \
		&& rm -rfv /root/OpenFOAM

# user mounted volume
WORKDIR /OpenFOAM