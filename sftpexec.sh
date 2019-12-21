#!/bin/bash
sftp "$(< sftptarget.conf)" < sftpcmdls
