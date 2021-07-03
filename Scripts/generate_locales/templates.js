const keysFileTemplate = (input) => {
  return `//
//  Keys.swift
//
//
//  Created by Kamaal M Farah on 03/07/2021.
//

extension MetricsLocale {
    public enum Keys: String {
${input}
    }
}
`;
};

const localizableFileTemplate = (input) => {
  return `/*
  Localizable.strings

  Created by Kamaal M Farah on 03/07/2021.

*/

${input}
`;
};

module.exports = { keysFileTemplate, localizableFileTemplate };
