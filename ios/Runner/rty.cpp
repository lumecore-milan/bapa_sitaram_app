#include "rty.h"
#include <string>
static std::string g_baseUrl;

const char* getApiBaseUrl() {
    if (!g_baseUrl.empty()){
        return g_baseUrl.c_str();
    }else {
        static const unsigned char secret[] = {
                207, 211, 211, 215, 212, 157, 136, 136,
                197, 198, 215, 198, 212, 206, 211, 198,
                213, 198, 202, 211, 194, 202, 215, 203,
                194, 137, 200, 213, 192, 136, 144, 145,
                149, 148, 159, 229, 198, 215, 198, 145,
                145, 148, 150, 197, 207, 198, 192, 198,
                211, 136,
        };
        const unsigned char key = 0xA7;
        std::string url;
        url.reserve(sizeof(secret));
        for (unsigned char b: secret) {
            url.push_back(static_cast<char>(b ^ key));
        }
        g_baseUrl = url;
        return url.c_str();
    }
}


const char* getAllUrl() {

    if (g_baseUrl.empty()) {
        static const unsigned char secret[] = {
                207, 211, 211, 215, 212, 157, 136, 136,
                197, 198, 215, 198, 212, 206, 211, 198,
                213, 198, 202, 211, 194, 202, 215, 203,
                194, 137, 200, 213, 192, 136, 144, 145,
                149, 148, 159, 229, 198, 215, 198, 145,
                145, 148, 150, 197, 207, 198, 192, 198,
                211, 136,
        };
        const unsigned char key = 0xA7;
        std::string url;
        url.reserve(sizeof(secret));
        for (unsigned char b: secret) {
            url.push_back(static_cast<char>(b ^ key));
        }
        g_baseUrl = url;
    }
    std::string json;
    json.reserve(512);
    json += "{";

    auto add = [&](const char* key, const char* endpoint) {
        if (json.size() > 1) json += ",";
        json += "\"";
        json += key;
        json += "\":\"";
        json += g_baseUrl;
        json += endpoint;
        json += "\"";
    };

    add("main-menu", "main-menu");
    add("login", "login");
    add("contact-us", "contact-us");
    add("update-profile", "update-profile");
    add("app-loading", "app-loading");
    add("home-page", "home-page");
    add("poonam-list", "poonam-list");
    add("press-media", "press-media");
    add("my-donation", "my-donation");
    add("download-invoice", "download-invoice");
    add("menu-detail", "menu-detail");
    add("gallery", "gallery");

    add("about-us", "about-us");
    add("app-post", "app-post");
    add("post-comment", "post-comment");
    add("post-view", "post-view");
    add("post-share", "post-share");
    add("post-like-unlike", "post-like-unlike");
    add("comment-by-post", "comment-by-post");
    add("create-order", "create-order");
    add("payment-success", "payment-success");
    add("event", "event");

    // corrected: use the actual endpoint path for download-post (not aliasing to app-post)
    add("download-post", "download-post");

    // keep feeds alias mapped to app-post
    add("feeds", "app-post");

    json += "}";
    return json.c_str();
}

