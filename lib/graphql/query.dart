String customerInfo = 
  '''{
    customer {
      firstname
      lastname
      email
      addresses {
        id
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
        default_billing
        default_shipping
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
        price_tiers {
          final_price {
            value
            currency
          }
        }
      }
      prices {
        row_total {
          value
          currency
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

String wishlist = '''{
  customer{
    wishlist {
      id
      items {
        id   
        product{
          name
          sku
          image{
            url
          }
          price_range{
            minimum_price{
              regular_price{
                value
                currency
              }
              final_price{
                value
                currency
              }
              discount {
                amount_off
                percent_off
              }
            }
          }
        }
      }
      items_count
    }
  }
  
}''';