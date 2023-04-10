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

String updateCustomerAddress = '''
  mutation UpdateAddress(
    \$id: Int!,
    \$street: [String]!,
    \$city: String!,
    \$postcode: String!,
    \$default_billing: Boolean!,
    \$default_shipping: Boolean!,
  ){
    updateCustomerAddress(
      id: \$id
      input: { 
        street: \$street, 
        city: \$city, 
        postcode: \$postcode ,
        default_billing: \$default_billing,
        default_shipping: \$default_shipping
      }
    ) {
      id
      street
      city
      postcode
    }
  }
''';