#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------
#-----------------------------------------------------------------------------
# Define a function for parsing and reporting XINDEX output results
function(ReportXINDEXResult PACKAGE_NAME DIRNAME OUTPUT)
   foreach (line ${OUTPUT})
      # the XINDEX will always check the integrity of the routine using checksum
      if(line MATCHES "^[A-Z0-9][^ ]+ +\\* \\* .*[cC]hecksum:.*")
        string(REGEX MATCH "^[A-Z0-9]+[^ ]" routine_name "${line}")
      elseif(line MATCHES "F -|W -")
        # assume the path to the XINDEX package exception list is DIRNAME\XindexException
        # also assume the file name is ${PACKAGE_NAME}.${routinename}
        set(ExceptionFound FALSE)
        if (EXISTS ${DIRNAME}/XindexException/${PACKAGE_NAME}.${routine_name})
            file(STRINGS ${DIRNAME}/XindexException/${PACKAGE_NAME}.${routine_name} ExceptionList)
          foreach (Exception ${ExceptionList})
            string(STRIP "${line}" newline)
            # this is quite stricty to ensure the text is the exactly the same
            if ("${Exception}" STREQUAL "${newline}")
              set(ExceptionFound TRUE)
              break()
            endif()
          endforeach()
        endif()
        if (NOT ExceptionFound)
          message("${routine_name} in package ${PACKAGE_NAME}:\n${line}")
        endif()
      endif()
   endforeach()
endfunction()
