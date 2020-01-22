enum Environment { DEV, PROD }

class Constants {
  static Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.devConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get API_URL {
    return _config[_Config.API_URL];
  }
}

class _Config {
  static const API_URL = "API_URL";

  static Map<String, dynamic> devConstants = {
    API_URL: "http://171.244.49.71:7009/api",
  };


  static Map<String, dynamic> prodConstants = {
    API_URL: "http://103.57.223.151/api",
  };
}