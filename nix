#!/usr/bin/env nix-shell
#!nix-shell -i python -p pythonPackages.click

import click
import shlex
import subprocess


# helper methods

def run(command):

    if isinstance(command, basestring):
        command = shlex.split(command)

    p = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        )

    out = []
    while True:
        line = p.stdout.readline()
        if line == '' and p.poll() is not None:
            break
        if line != '':
            click.secho(line.rstrip('\n'))
            out.append(line)

    return p.returncode


# commands

@click.group()
def main():
    """Nix package manager.

        Proposal to impove UX of nix-* command line tools.

        More documentation can be found at:

            https://nixos.org/nix/manual

    """


@main.command()
@click.argument('pkg', type=str)
def install(pkg):
    """Install package.
    """
    run('nix-env -i %s' % pkg)


@main.command()
@click.argument('pkg', type=str)
def uninstall(pkg):
    """Uninstall package.
    """
    run('nix-env -e %s' % pkg)


@main.command()
@click.argument('pkg', default=None, required=False, type=str)
def search(pkg):
    """Search available packages.
    """
    if pkg:
        pkg = '".*%s.*"' % pkg
    else:
        pkg = ''
    run('nix-env -qaP ".*%s.*"' % pkg)


@main.command()
@click.argument('pkg', default=None, required=False, type=str)
def list(pkg):
    """List currently installed packages.
    """
    if pkg:
        pkg = '".*%s.*"' % pkg
    else:
        pkg = ''
    run('nix-env -q --installed %s' % pkg)


@main.command()
@click.argument('pkg', default=None, required=False, type=str)
def upgrade(pkg):
    """Upgrade package.
    """
    if not pkg:
        pkg = ''
    run('nix-env -u %s' % pkg)


if __name__ == "__main__":
    main()