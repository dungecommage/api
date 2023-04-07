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

String createAcc = '''
  mutation CreateCustomerMutation(
    \$firstname: String!,
    \$lastname: String!,
    \$email: String!, 
    \$pass: String!
  ) {
    createCustomer(
      input: {
        firstname: \$firstname
        lastname: \$lastname
        email: \$email
        password: \$pass
        is_subscribed: true
      }
    ){
      customer{
        firstname
        lastname
        email
        is_subscribed
      }
    }
  }
''';

String deleteCustomerAddress = '''
  mutation DeleteAddress(\$id: Int!){
    deleteCustomerAddress(
      id: \$id
    )
  }
''';