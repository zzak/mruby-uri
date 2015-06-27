#
# URI support for Ruby
#
# Author:: Akira Yamada <akira@ruby-lang.org>
# Documentation:: Akira Yamada <akira@ruby-lang.org>, Dmitry V. Sabanin <sdmitry@lrn.ru>
# License::
#  Copyright (c) 2001 akira yamada <akira@ruby-lang.org>
#  You can redistribute it and/or modify it under the same term as Ruby.
# Revision:: $Id$
#
# See URI for documentation
#

module URI
  # :stopdoc:
  VERSION_CODE = '000911'
  VERSION = VERSION_CODE.scan(/../).collect{|n| n.to_i}.join('.')
  # :startdoc:
end
