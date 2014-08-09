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
from tornado.options import define, options

define("port", default=8889, help="run on the given port", type=int)


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        print "tornado.ioloop.IOLoop.instance().start()"
        print "self.write(Hello, world)"
        print self.request.headers
        print "......."+str(self.request.arguments)
        arguments = self.request.arguments
        arguments = dict([(k, v[0] if len(v) > 0 else "") for k, v in arguments.items()])
        print ",,,,,,,,,,,"+str(arguments)
        self.write("Hello, world\nYour headers:%s\your para:%s"%(self.request.headers,str(arguments)))
def main():
    tornado.options.parse_command_line()
    application = tornado.web.Application([
        (r"/EBS", MainHandler),
    ])
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()

