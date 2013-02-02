
    set(AVRSIZE_PROGRAM /Applications/Arduino.app/Contents/Resources/Java/hardware/tools/avr/bin/avr-size)
    set(AVRSIZE_FLAGS --target=ihex -d)

    execute_process(COMMAND ${AVRSIZE_PROGRAM} ${AVRSIZE_FLAGS} ${FIRMWARE_IMAGE}
                    OUTPUT_VARIABLE SIZE_OUTPUT)

    string(STRIP "${SIZE_OUTPUT}" SIZE_OUTPUT)

    # Convert lines into a list
    string(REPLACE "\n" ";" SIZE_OUTPUT "${SIZE_OUTPUT}")

    list(GET SIZE_OUTPUT 1 SIZE_ROW)

    if(SIZE_ROW MATCHES "[ \t]*[0-9]+[ \t]*[0-9]+[ \t]*[0-9]+[ \t]*([0-9]+)[ \t]*([0-9a-fA-F]+).*")
        message("Total size ${CMAKE_MATCH_1} bytes")
    endif()