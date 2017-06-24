#!/bin/bash

set -e

hugo server --baseUrl localhost/blog --theme=after-dark --buildDrafts

