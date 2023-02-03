# datastore-support repo overview

The datastore-support repo contains tools and utilities for managing the ecosystem of services comprising a deployment of the MPEX datastore Java server applications.  These applications offer APIs for storing and retrieving data captured from a running particle accelerator (or other large experimental facility), providing a platform for building machine learning and other analytics tools for use within control systems at those facilities.  The [datastore](https://github.com/osprey-dcs/datastore) application provides an ingestion service for capturing incoming data, and the [datastore-service](https://github.com/osprey-dcs/datastore-service) application offers a query service.

The API provided by these servers is implemented using the [gRPC](https://grpc.io/) high performance remote procedure call (RPC) framework.  The server applications utilize both [InfluxDB](https://www.influxdata.com/) time series database platform and [MongoDB](https://www.mongodb.com/) document-oriented/NoSQL database platform.

The datastore-support repo provides tools for managing the supporting services required to run the Java server applications.  It can be used for production/demo/test deployments of the applications as well as development environments supporting Java development work on the server applications as well as JavaScript development efforts to create a [React](https://reactjs.org/) based [web application](https://github.com/craigmcchesney/datastore-web-app) for navigating the datastore and a [Node.js](https://nodejs.org/en/) based [server](https://github.com/craigmcchesney/datastore-server-app) for deploying the web app and augmenting the datastore server APIs.

Deployments of the datastore-support ecosystem utilize the [datastore-deployment](https://github.com/craigmcchesney/datastore-deployment) github repo for managing deployment-specific artifacts like config files and crontabs.  A new branch should be created in that repo for each deployment, starting from a branch used for a similar deployment configuration.

## ecosystem support services

I decided to utilize docker-based containers for the support services that are required by the Java server applications to simplify deploying new systems.  This is great for development, testing, and demo environments.  It may be desirable to use the full installation of the database packages on a real production deployment for performance and administrative reasons.  A lot of the datastore-support repo tools would be useful for either type of deployment (with a little bit of work).

The datastore-support environment utilizes docker containers for deploying the following services:

* InfuxDB - time series database platform
* MongoDB - document-oriented / NoSQL database platform
* [envoy](https://www.envoyproxy.io/) - proxy engine for converting web application traffic generated by web browsers using HTTP to HTTP/2 for compatibility with gRPC Java server

## datastore ecosystem directory layout

The scripts assume that there is a directory "~/datastore" in the user's home directory that contains all the other datastore repos in subdirectories.  This is so things are a bit more contained than having several subdirectories located in the home directory, and makes it easier to zip up an installation to get a jumpstart on another deployment.  I might make a new datastore-ecosystem repo that contains all the other repos as git submodules.  Right now it's easier to just use links or nested git repos since everything is still under development.  Once we get to official versioned releases, that might change.

Here is the assumed directory structure beneath ~/datastore, followed by a brief description of the various subdirectories:

<pre>
datastore-deployment:
---- bin
---- custom
---- var

datastore-java:
---- datastore
---- datastore-client-lib
---- datastore-client-spring-boot-starter
---- datastore-grpc
---- datastore-provider-lib
---- datastore-provider-spring-boot-starter
---- datastore-service
---- mpex-sdp

datastore-javascript:
---- datastore-server-app
---- datastore-web-app

datastore-support:
---- bin
---- datastore-file-repository
---- docker
---- env
---- protoc-output
</pre>

#### datastore-deployment

Branch of [datastore-deployment repo](https://github.com/craigmcchesney/datastore-deployment), subdirectories include:

* bin: symbolic links to system executables with variable locations on hosts
* custom: customizations including environment variables and cron file etc
* var: ignored by version control, includes subdirectories for lock and log files

#### datastore-java

Clones of the various datastore Java application repos, including:

* [datastore](https://github.com/osprey-dcs/datastore)
* [datastore-client-lib](https://github.com/osprey-dcs/datastore-client-lib)
* [datastore-client-spring-boot-starter](https://github.com/osprey-dcs/datastore-client-spring-boot-starter)
* [datastore-grpc](https://github.com/osprey-dcs/datastore-grpc)
* [datastore-provider-lib](https://github.com/osprey-dcs/datastore-provider-lib)
* [datastore-provider-spring-boot-starter](https://github.com/osprey-dcs/datastore-provider-spring-boot-starter)
* [datastore-service](https://github.com/osprey-dcs/datastore-service)
* [mpex-sdp](https://github.com/osprey-dcs/mpex-sdp)

#### datastore-javascript

Clones of the datastore Javascript application repos, including: 

* [datastore-server-app](https://github.com/craigmcchesney/datastore-server-app)
* [datastore-web-app](https://github.com/craigmcchesney/datastore-web-app)

#### datastore-support

Clone of [this repo](https://github.com/craigmcchesney/datastore-support).  Because they are the focus of this repo, a more detailed description of each subdirectory is given below.

##### bin

The bin directory includes shell scripts for managing individual services, starting and stopping the entire service ecosystem, creating/removing/starting/stopping docker containers, running the gRPC protoc compiler (for [generating JavaScript stubs](https://github.com/grpc/grpc-web) from the Java server application gRPC API [protocol buffer](https://developers.google.com/protocol-buffers/docs/overview) files), and starting the [eclipse](https://www.eclipse.org/ide/) (Java) and [webstorm](https://www.jetbrains.com/webstorm/) (JavaSecript) development environments.

The scripts in the bin directory can be grouped into categories for further discussion:

###### building datastore Java

* datastore-java-build

###### managing datastore Java applications
* datastore-query-svc-start
* datastore-query-svc-status
* datastore-query-svc-stop

###### managing docker-based support services

* support-services-create
* support-services-rm
* support-services-start
* support-services-status
* support-services-stop

###### managing ecosystem services

* ecosystem-start-dev-java
* ecosystem-start-dev-web-app
* ecosystem-start-full
* ecosystem-start-specified-services
* ecosystem-status
* ecosystem-stop

###### development tools

* eclipse
* run-protoc
* webstorm

##### docker
<pre>
docker:
docker-compose.yml
envoy.mac.yaml
envoy.yaml
influxdata
mongodata
seed
</pre>

The docker directory includes configuration files for creating [docker containers](https://www.docker.com/resources/what-container/) for the support services.  A [docker-compose](https://docs.docker.com/compose/) configuration (docker-compose.yml) is provided for running influxdb, mongodb, and mongo express (web portal for MongoDB).  

A separate docker configuration (envoy.yaml)  is included for creating a container running the envoy proxy.  Note that there is now a MacOS specified file envoy.mac.yaml (that I think is also supposed to be used for Windows).  See the [grpc-web example](https://github.com/grpc/grpc-web/tree/master/net/grpc/gateway/examples/helloworld) for more details about docker container configuration and creation and the differences for Mac/Windows.

##### env

<pre>
crontab.datastore-support
crontab.datastore-support-dev-java
crontab.datastore-support-dev-web-app
datastore-env
</pre>

The env directory includes scripts for setting up the Linux environment for the user running the ecosystem.  The "datastore-env" script should be called by the Linux user's .bashrc script, and adds environment variables for use by the datastore-support repo's scripts (in bin directory).  It also includes template crontab files for different kinds of deployments.  The crontab.datastore-support template starts the full ecosystem including support services, Java server applications, and Javascript server/web applications.  There are also crontab templates for development VMs to be used for either Java or JavaScript development that only start the support services and whatever other parts of the ecosystem are needed for development.

## using the datastore-support repo tools

Below are the recommended steps for creating a new deployment of the datastore ecosystem using the tools provided in this datastore-support repo.  You might also consider copying a VirtualBox VM set up for Java and JavaScript development, or installing and tailoring a zipfile copy of the ~/datastore directory, discussed in more detail below.  Both are a good way to get a jumpstart over installing from scratch.

### create root directory ~/datastore

### create branch of datastore-deployment repo and clone to root datastore directory

This repo is intended to be used with the datastore-deployment repo.  A new branch of that repo should be created for the new deployment and cloned to ~/datastore/datastore-deployment in the home directory of the Linux user that will run the service ecosystem.  The config and crontab files should be tailored as appropriate for the deployment including influxdb/mongodb authentication details, which services to start (e.g., production vs. development), etc.

Note that it might be easiest to start with a copy of the datastore-deployment directory from an existing deployment, tailor/customize the copied files, and create a new git branch for the new deployment.

### clone datastore-support repo to root datastore directory

The datastore-support repo should be cloned to ~/datastore/datastore-support.

### clone datastore java repos to ~/datastore/datastore-java directory

The datastore Java repos are listed above.  They should be cloned to the datastore-java directory.

### clone datastore javascript repos to ~/datastore/datastore-javascript directory

If it is desired to use the web application and node corresponding node server, those repos should be cloned to the datastore-javascript directory.

### create docker containers for support services

The ~/datastore/datastore-support/bin/support-services-create script is used to create docker containers for influxdb, mongodb, and envoy proxy.

### use influxdb portal to create "bucket"

After creating docker containers for the support services, the InfluxDB [web portal running in the docker container](http://localhost:8086/) is used to initialize the "bucket" for the datastore applications (user/bucket name "datastore", organization "ospreydcs").

NOTE: it is on the todo list to create the docker container for InfluxDB using config file values for user, bucket, and organization name etc but for now it works the other way around.

### check mongodb installation using mongoexpress

The [mongo express web portal](http://localhost:8081/) can be used to navigate the MongoDB running in the docker container.  The initial database contains no schema as you'd expect to see in a relational database platform.  The ingestion services initializes the database structure and builds on it as data are added.

### use appropriate ecosystem-start variant to bring up the system

The ~/datastore/datastore-support/bin/ecosystem-start-full script is used to bring up a full ecosystem with support services, Java servers, and JavaScript server/web applications.  The ecosystem-start-dev-java and ecosystem-start-dev-web-app scripts can be used to bring up services for a development system.

### add the ecosystem-start script invocation to crontab

The crontab templates in ~/datastore/datastore-support/env can be used to create a crontab for the user that runs the ecosystem.  Choose the template for the appropriate ecosystem-start script variant from above.  The crontab includes a "reboot" entry that will start the ecosystem when the system/VM is booted.

### java development

For Java development, use the ~/datastore/datastore-support/bin/eclipse script to run eclipse.  The datastore repos are meant to be installed to and loaded from ~/datastore/datastore-support/repos.

### javascript development

For Javascript development, use the ~/datastore/datastore-support/bin/webstorm script to run webstorm.  The React web application repo is cloned to ~/datastore/datastore-web-app.  The Node.js server is cloned to ~/datastore/datastore-server-app, and includes a symbolic link called "client" which points to the datastore-web-app directory.  For now there are 2 independent repos, one for the client and one for the server.  At some point, I might merge this to use a single repo for both, or to use a git submodule for the client within the server directory.

### web application

If the Node.js server for the web application is running, it can be accessed at http://localhost:9000 .  If the web application is started in the webpack development server, it will be found at http://localhost:3000 .
