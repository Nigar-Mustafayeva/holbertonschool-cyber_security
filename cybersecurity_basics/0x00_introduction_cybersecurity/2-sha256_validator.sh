#!/bin/bash
sha256sum * > test_file
sha256sum -c test_file
