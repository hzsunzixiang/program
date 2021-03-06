#!/usr/bin/env python
#
# Copyright 2009 Facebook
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
from test import TestHandler

from tornado.options import define, options

#define("port", default=8889, help="run on the given port", type=int)


class TestHandler(tornado.web.RequestHandler):
    def __init__(self,requestHandler):
        self.requestHandler = requestHandler
    def get(self):
        requestHandler.write("Hello, world")
