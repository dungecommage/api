String customerInfo = 
  '''{
    customer {
      firstname
      lastname
      email
      addresses {
        firstname
        lastname
        street
        city
        region {
          region_code
          region
        }
        postcode
        country_code
        telephone
      }
    }
  }''';

String customerOrders = '''{
  customerOrders {
    items {
      order_number
      id
      created_at
      grand_total
      status
      created_at
    }
  }
}''';

String customerCart= '''{
  customerCart{
    id
    email
    items{
      __typename
      id
      quantity
      product{
        id
        sku
        name
        thumbnail{
          url
        }
        price_range {
          minimum_price {
            regular_price {
              value
              currency
            }
            final_price {
              value
              currency
            }
          }
        }
      }
      ... on ConfigurableCartItem{
        id
        configurable_options{
          id
          value_id
          value_label
          option_label
        }
      }
    }
    prices {
      subtotal_excluding_tax{
        value
        currency
      }
      grand_total {
        value
        currency
      }
    }
  }
}''';