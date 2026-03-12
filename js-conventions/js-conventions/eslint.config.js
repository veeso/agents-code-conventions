// ESLint 9 flat config for Airbnb JavaScript conventions.
// Requires: npm install --save-dev eslint eslint-config-airbnb-extended
//
// For React projects, add the React plugin:
//   npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y
//
// Reference: https://github.com/NishargShah/eslint-config-airbnb-extended

import { airbnbBase } from "eslint-config-airbnb-extended";

export default [
  ...airbnbBase,
  {
    rules: {
      // Project-specific rule overrides go here.
    },
  },
  {
    ignores: ["node_modules/", "dist/", "build/", "coverage/"],
  },
];
