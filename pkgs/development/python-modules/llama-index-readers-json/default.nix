{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-json";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_json";
    inherit version;
    hash = "sha256-mS8nEK8LV1wVh0wV7W8EujLH7QcPagHI4P5cT0bHAJ4=";
  };

  build-system = [ poetry-core ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.json" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for Json";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-json";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
