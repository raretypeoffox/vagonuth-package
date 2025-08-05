-- Alias: version
-- Attribute: isActive

-- Pattern: ^version$

-- Script Code:
if not VagoPackage or not VagoPackage.Version then
  printMessage("Version", "Unknown Vagonuth Package version")
end

printMessage("Version", "You are on Vagonuth Package " .. VagoPackage.Version)