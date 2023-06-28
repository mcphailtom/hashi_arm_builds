# Hashicorp ARM builds
As the name suggests this is some automation to produce ARMv6 and ARMv8 (AARCH64) builds for hashicorp products, 
specifically:

1. [Consul](https://github.com/hashicorp/consul) 
2. [Nomad](https://github.com/hashicorp/nomad)
3. [Vault](https://github.com/hashicorp/vault)

I was putting together my home Pi cluster with a Pi 4 and some Pi Zeros and discovered that the release ARMv6 builds
for nomad did not work. Rather than spend any time working out why I just recompiled them and then decided to do the same
for consul and vault because.......it seemed like a good idea.

The end result should be working releases of ARMv6 and ARMv8 builds in sync with the official hashicorp releases.

At the risk of stating the obvious, these are not intended for anything vaguely like a production workload. If you need
to run your production workloads on a Pi Zero then you may want to reconsider some life choices. They are provided with
all care and no responsibility.

Enjoy :)