# Web server application module example

This folder contains example [Terraform](https://www.terraform.io/) configuration that define a module for instantiating
a debian buster VM with a minimal python http server.

The configuration returns the [AMI ID](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) of the lastest
debian buster version and the rendreder configuration script for the http server.
