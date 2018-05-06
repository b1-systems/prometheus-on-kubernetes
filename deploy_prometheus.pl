#!/usr/bin/perl -w
## vim: set syn=on ts=4 sw=4 sts=0 noet foldmethod=indent:
## purpose: Create Prometheus on Kubernetes Cluster.
## copyright: B1 Systems GmbH <info@b1-systems.de>, 2018.
## license: GPLv3+, http://www.gnu.org/licenses/gpl-3.0.html
## author: Jeremias Brödel <broedel@b1-systems.de>, 2018.
## version: 0.1: initial version

use strict;
use warnings;
use File::Which;


# Needed variables
my @exe_path = which('kubectl');
my $kubectl_binary = 'v1.10.2';
my $cmd = which('curl');
my $chmod = which('chmod');
my $chmod_flag = '+x';
my $move = which('mv');
my $kubectl_command = 'kubectl';
my $local_path = '/usr/local/bin/';
my $kubectl_url = "https://storage.googleapis.com/kubernetes-release/release/$kubectl_binary/bin/linux/amd64/kubectl";
my $kubectl_flag = '-LO';
my $kubectl_namespace = 'monitoring';
my $kubectl_yaml_path = '/srv/git/prometheus_setup/YAML-FILES/.';
my $kubectl_create_flag = 'create';
my $kubectl_deploy_flag = '-f';
my $kubectl_namespace_flag = 'namespace';



if( @exe_path ){
   print("File exists and readable\n");
   print("Start Prometheus deployment\n");
   my $create_namespace = "$kubectl_command $kubectl_create_flag $kubectl_namespace_flag $kubectl_namespace";
   system($create_namespace);
   $kubectl_command .= " --namespace=$kubectl_namespace";
   $kubectl_command .= " $kubectl_create_flag $kubectl_deploy_flag";
   $kubectl_command .= " $kubectl_yaml_path";
   system($kubectl_command);
   
}else{
   print("File does not exists and readable\n");
   $cmd .= " $kubectl_flag";
   $cmd .= " $kubectl_url";
   system($cmd);
   $chmod .= " $chmod_flag";
   $chmod .= " $kubectl_command";
   system($chmod);
   $move .= " $kubectl_command";
   $move .= " $local_path$kubectl_command";
   system($move);
   print("Start Prometheus deployment\n");
   my $create_namespace = "$kubectl_command $kubectl_create_flag $kubectl_namespace_flag $kubectl_namespace";
   system($create_namespace);
   $kubectl_command .= " --namespace=$kubectl_namespace";
   $kubectl_command .= " $kubectl_create_flag $kubectl_deploy_flag";
   $kubectl_command .= " $kubectl_yaml_path";
   system($kubectl_command);
}
