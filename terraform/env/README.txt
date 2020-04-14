Bitpusher Reference Terraform Architecture
==========================================

This is the environment-differentiating directory.

This directory should differentiate 'dev1' from 'dev2' from 'dev-jsmith' from 'qa1' from 'qa-india' from 'stage' from 'prod-east' from 'prod-west'.

Environment names should be unique.

Each environment is an independent Terraform state and namespace.

For clarity, the environment directory name should be the same string as the "env" variable.

