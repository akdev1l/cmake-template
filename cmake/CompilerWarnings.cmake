# helloworld_set_warnings(<target>)
# Applies the project's warning flags to <target>. Honors HELLOWORLD_WARNINGS_AS_ERRORS.
function(helloworld_set_warnings target)
  if(MSVC)
    set(warnings /W4 /permissive-)
    if(HELLOWORLD_WARNINGS_AS_ERRORS)
      list(APPEND warnings /WX)
    endif()
  else()
    set(warnings
        -Wall
        -Wextra
        -Wpedantic
        -Wshadow
        -Wconversion
        -Wsign-conversion
        -Wold-style-cast
        -Wnon-virtual-dtor
        -Woverloaded-virtual
        -Wnull-dereference
        -Wdouble-promotion
        -Wformat=2
        -Wimplicit-fallthrough)
    if(HELLOWORLD_WARNINGS_AS_ERRORS)
      list(APPEND warnings -Werror)
    endif()
  endif()
  target_compile_options(${target} PRIVATE ${warnings})
endfunction()
