# Docker image for OpenFOAM 2.4.x with OpenMPI 1.6.5, CGAL-4.6.3 and swak4Foam-0.4.1 on Debian 8.11-slim
## Testing and Updating Legacy Code

Are you looking for an easy way to run and test your legacy OpenFOAM 2.4.x code on new systems? Look no further! Introduce the OpenFOAM 2.4.x Docker image, designed to address the challenges of installing the deprecated version on new systems. This image allows for easy testing of old code and updating to newer versions.


### How to use the image

1. Download the image with the following command:
```
docker image pull asaramet/openfoam-2.4.x
```

2. Create a container and mount your local folder with the container using the "-v" option. For example, to mount the current working directory:
```
docker run -v $(pwd):/OpenFOAM -it asaramet/openfoam-2.4.x
```

To mount the local folder `/path/to/local/folder` to the container's `/OpenFOAM` directory:
```
docker run -v /path/to/local/folder:/OpenFOAM -it asaramet/openfoam-2.4.x
```

This allows you to access the files in the mounted local folder within the container and also any changes made within the container will be reflected in the local folder.

By using the `-v` option, you are creating a volume, a way to store data outside the filesystem of the container. This will allow you to keep the data even if the container is deleted or recreated.

In this example, the local folder `/path/to/local/folder` is being mounted to the `/OpenFOAM` directory in the container. You can specify the local folder and the container directory according to your needs.

Please note that the local folder should exist before running the command, the `/path/to/local/folder` should be replaced by the full path of the local folder you want to mount.

3. Once inside the container, initialize the OpenFOAM environment variables using the command:
```
foamInit
```

4. To exit the container, use the `exit` command. To re-enter a running container, you can use the following commands:
```
# Get the container ID
docker container ls -a

# Start the container interactively
docker start -ai <CONTAINER ID>
```