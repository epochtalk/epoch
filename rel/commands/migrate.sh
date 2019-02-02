#!/bin/sh

release_ctl eval --mfa "Epoch.ReleaseTasks.migrate/0" --argv -- "$@"
