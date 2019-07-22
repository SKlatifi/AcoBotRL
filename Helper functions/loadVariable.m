function result = loadVar(fileName, variableName) 
    tmp = load(fileName, variableName);
    result = tmp.(variableName); 
end