#include <mbgl/platform/default/settings_json.hpp>
#include <fstream>

using namespace mbgl;

namespace {

std::string getSettingsPath() {
    std::string settingsFile("mbgl-native.cfg");

    const char *homeDirectory = getenv("HOME");
    if (homeDirectory) {
        settingsFile.insert(0, "/.config/mbgl-app/");
        settingsFile.insert(0, homeDirectory);
    }

    return settingsFile;
}

}

Settings_JSON::Settings_JSON() { load(); }

void Settings_JSON::load() {
    std::ifstream file(getSettingsPath());
    if (file) {
        file >> longitude;
        file >> latitude;
        file >> zoom;
        file >> bearing;
        file >> debug;
    }
}

void Settings_JSON::save() {
    std::ofstream file(getSettingsPath());
    if (file) {
        file << longitude << std::endl;
        file << latitude << std::endl;
        file << zoom << std::endl;
        file << bearing << std::endl;
        file << debug << std::endl;
    }
}

void Settings_JSON::clear() {
    longitude = 0;
    latitude = 0;
    zoom = 0;
    bearing = 0;
    debug = false;
}
