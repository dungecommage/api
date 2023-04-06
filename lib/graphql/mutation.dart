String createToken = '''
  mutation CreateCustomerToken(\$email: String!, \$pass: String!) {
    generateCustomerToken(
      email: \$email
      password: \$pass
    ) {
      token
    }
  }
''';

String revokeToken = '''
mutation {
  revokeCustomerToken {
    result
  }
}
''';

String changeCustomerPassword = '''
mutation ChangeCustomerPassword(\$pass: String!, \$npass: String!){
  changeCustomerPassword(
    currentPassword: \$pass
    newPassword: \$npass
  ) {
    firstname
    lastname
    email
  }
}
''';