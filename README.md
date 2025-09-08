# dotfiles

These are my dotfiles, turned personal infrastructure.

The dotfiles are still under the `config` folder. System configurations have
now mostly been migrated to the `machines` folder, the legacy host
configurations are still in `hosts`. User level configuration is under
`home`.

I have a couple of machines that serve different roles:

- fluorite: My personal laptop
- graphite: My desktop. Is also used to run gpu intensive loads such as LLMs
- halite: Another desktop, mostly used as a server. Hosts the majority of the
webservices and media storage due to available HDD space.
- lazurite: A VPS that acts as the entry point for external users. This is the one with the publicly exposed IP Address

The primary network that handles communication between these machines is
tailscale. A WIP is that the `kiesen.moe` domain should resolve to this
internal network. It'll require setting up a DNS-01 challenge. The
`kiesen.dev` domain already resolves to lazurite, but does not have any
available web services exposed currently.
