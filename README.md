NOTE: This repository is in a state of flux. It's being cleaned up for a re-factor.

eventstreamr [![Build Status](https://api.travis-ci.org/plugorgau/eventstreamr-station.svg?branch=master)](https://travis-ci.org/plugorgau/eventstreamr)
============

Single and multi room audio visual stream management.

Concepts
========

A station can have one or more roles. Only one controller can manage stations.

Roles
=====
* controller - Web based frontend for managing stations
* ingest - alsa/dv/v4l capture for sending to mixer
* mixer - DVswitch/streaming live mixed video. With the intention for this to be easily replaced by gstswitch
* stream - stream mixed video
* record - stream mixed video

Directories
===========
* baseimage - docs, notes, and tools for the base (OS) image
* station - station management scripts
* controller - controller stack


Station Script Requirements
===========================

See package.deps for list of packages required
