#!/bin/bash
ip a | grep "inet\ " | grep -iv "127.0.0.1" | cut -d\t -f2 | cut -d" " -f2 | cut -d"/" -f1
