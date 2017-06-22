#
# Copyright (c) 2016 by appPlant GmbH. All rights reserved.
#
# @APPPLANT_LICENSE_HEADER_START@
#
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apache License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://opensource.org/licenses/Apache-2.0/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#
# @APPPLANT_LICENSE_HEADER_END@

module Orbit
  # Colorized ORBIT logo
  LOGO = <<-logo.set_color(OS.posix? ? 208 : :light_yellow).freeze
          `-/++++++/:-`
      `/yhyo/:....-:/+syyy+:`
    .yd+`                `-+yds:     `
   om/                        -+``sdyshh.
  sd`                            hy    om
 /N.                             od.  `yd
 do                               /yyyy+`.`
`N:                                      /ms`
`M-                                        +m+
 m+                                         .+`
 od                                            +`
 .N:                     -oyyyyyo-             N.         +m.   /.
  om`                  -dy-     -yd-    `  .`  N. `.`           d/``
   hy                 -N-         -N-   Nss+/  Nys+/oh+   -m  -oNyoo
   `dy                yy           yy   N/     N-    `m:  -m    d:
    `dy               om           mo   N.     N.     h/  -m    d:
      yd.              hd.       .hh`   N.     N.    -N.  -m    d:
       +m:              :hho///ohh:     N.     Nys++sy-   -m    oh+o
        .dy`               .:::.                  ``              ``
          +m+
           `od+
             `od+`
               `+ds
logo
end
