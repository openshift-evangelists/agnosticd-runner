# Agnosticd runner

This repository builds a helper script and image to make it easy to create OCP-4 clusters using [agnosticd](https://github.com/redhat-cop/agnosticd).

The image is built and available on Quay.io

```bash
quay.io/osevg/agnosticd-runner
```

## Run the image

It's as easy as:

```bash
docker run -it --rm \
      -v $(pwd)/config:/opt/app-root/data \
      -v $(pwd)/ssh:/opt/app-root/src/.ssh \
      quay.io/osevg/agnosticd-runner create
```

__NOTE__: You'll need to mount as volumes to the container the configuration and ssh keys.

And to run the image you'll need 3 things:

- An AWS account properly set-up
- The configuration to be applied
- A EC2 ssh key-pair to be used

Following is a guide on how to get the 3 things done:

### Set up an AWS account and get the credentials

Create an AWS account and use that (root account), or create a user in AWS and give it enough
permissions to provision using agnosticD. See [agnosticd docs](https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#aws-permissions-and-policies).

You also need a Route53 Hosted Zone and an EC2 ssh key-pair as documented [here](https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#aws-existing-resources)

The EC2 ssh key will need to be mounted into the container in the `/opt/app-root/src/.ssh` folder, as documented above. The name of the key is specified as a configuration parameter `key_name`.

### Create a tweak the desired configuration to be applied

To create the configuration you can run the `agnosticd-runner` script or image and use the following subcommands:

```bash
agnosticd-runner create-env
```

This will create a file named `my_environment-variables.yml` that you should edit/tweak to your own needs.

__NOTE__: At the end of this configuration file you'll need to provide your OCP token from try.openshift.com

__NOTE__: The EC2 ssh key needs to be in the region you'll use. Follow the [doc](https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#aws-existing-resources) on how to add the key on all the regions you want.

And to create the AWS credentials sample secret:

```bash
agnosticd-runner create-secret
```

This will not create a file, but will show you the format the file should need. You need to get this information from the AWS console.


## Building the container

Build the container:

```bash
docker build -t "quay.io/osevg/agnosticd-runner" .
```

Test the container:

```bash
docker run -it --rm \
      -v $(pwd)/config:/opt/app-root/data \
      -v $(pwd)/ssh:/opt/app-root/src/.ssh \
      --entrypoint bash \
      quay.io/osevg/agnosticd-runner
```

To create a cluster:

```bash
agnostic-runner create
```

To destroy the cluster:

```bash
agnostic-runner destroy
```

For all the options you can just do:

```bash
agnostic-runner help
```
