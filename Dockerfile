FROM debian:bookworm-slim

ARG TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
ARG TOOLCHAIN_MD5=2383e4eb4ea23f248d33adc70dc3227e
ARG PICO_SDK_PATH="/usr/share/pico-sdk"

ENV PICO_SDK_PATH="${PICO_SDK_PATH}"
ENV PATH="${PATH}:/usr/share/gcc-arm-none-eabi/bin"

RUN apt-get update && apt-get install -y --no-install-recommends                            \
    ca-certificates                                                                         \
    curl                                                                                    \
    gcc-12                                                                                  \
    make                                                                                    \
    cmake                                                                                   \
    git                                                                                     \
    python3                                                                                 \
    lbzip2                                                                                  \
    build-essential                      

RUN mkdir /usr/share/gcc-arm-none-eabi                                                      \
 && curl --location "${TOOLCHAIN_URL}" --output /tmp/toolchain.tar                          \
 && echo "${TOOLCHAIN_MD5} /tmp/toolchain.tar" | md5sum -c -                                \
 && tar -C /usr/share/gcc-arm-none-eabi/ -xf /tmp/toolchain.tar --strip-components 1        \
 && rm /tmp/toolchain.tar                                                                   

RUN git clone --depth 1 https://github.com/raspberrypi/pico-sdk.git "${PICO_SDK_PATH}"      \
 && cd "${PICO_SDK_PATH}" && git submodule update --init --recursive                        \
 && cmake -S "${PICO_SDK_PATH}/tools/pioasm" -B /tmp/pioasm -DPIOASM_VERSION_STRING="2.2.0" \
 && cmake --build /tmp/pioasm -j                                                            \
 && cp /tmp/pioasm/pioasm /usr/local/bin/                                                   \
 && rm -rf /tmp/pioasm

RUN git clone --depth 1 https://github.com/raspberrypi/picotool.git /tmp/picotool           \
 && cd /tmp/picotool                                                                        \
 && git submodule update --init --recursive                                                 \
 && cmake -S . -B build                                                                     \
 && cmake --build build -j                                                                  \
 && cmake --install build                                                                   \
 && rm -rf /tmp/picotool
 