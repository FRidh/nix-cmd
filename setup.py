from setuptools import setup

setup(
      name='nix-cmd',
      version='0.0',
      description="The `nix` command provides a user-friendly way to use the Nix package manager",
      license='LICENSE',
      scripts = ["bin/nix"],
      zip_safe=False,
      install_requires=[
          'click',
          ],
      )