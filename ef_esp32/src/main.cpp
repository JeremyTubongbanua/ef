#include <Arduino.h>
#include <WiFiClientSecure.h>
#include <SPIFFS.h>
#include "at_client.h"
#include <constants.h>

void setup()
{
    const auto *esp32 = new AtSign("@tastelessbanana");
    const auto *flutter = new AtSign("@jeremy_0");

    const auto keys = keys_reader::read_keys(*esp32);

    auto *at_client = new AtClient(*esp32, keys);

    at_client->pkam_authenticate(SSID, PASSWORD);

    // 1. get code
    // @esp32:num.soccer0@flutter
    auto *shared_with_us = new AtKey("num", flutter, esp32);
    shared_with_us->namespace_str = "soccer0";

    std::uint32_t num = stoi(at_client->get_ak(*shared_with_us));

    std::uint32_t new_num = num + 1;

    // 2. put code
    // @flutter:num.soccer0@esp32
    auto *shared_with_flutter = new AtKey("num", esp32, flutter);
    shared_with_flutter->namespace_str = "soccer0";

    at_client->put_ak(*shared_with_flutter, std::to_string(new_num));

    std::cout << "current num: " << num << "\n" << "new num: " << new_num << "\n";


}

void loop()
{

}