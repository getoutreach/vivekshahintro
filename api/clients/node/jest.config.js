module.exports = {
  collectCoverage: true,
  collectCoverageFrom: ['**/src/**'],
  coveragePathIgnorePatterns: ['<rootDir>/src/grpc/'],
  moduleNameMapper: {
    ['@outreach/vivekshahintro-client']: '<rootDir>/src'
  },
  modulePathIgnorePatterns: ['dist', '\\.(json)$'],
  preset: 'ts-jest',
  testEnvironment: 'node',
  verbose: true
};
