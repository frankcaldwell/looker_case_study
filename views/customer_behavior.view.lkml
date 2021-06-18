view: customer_behavior {
  derived_table: {
    sql: SELECT
            order_items.user_id as user_id
            , COUNT(DISTINCT order_items.order_id) as lifetime_orders
            , MIN(order_items.created_at) as first_order
            , MAX(order_items.created_at) as latest_order
            , SUM(case when order_items.status in ('Returned','Cancelled')
                       then 0
                      else order_items.sale_price end) as lifetime_revenue
          FROM order_items
          GROUP BY order_items.user_id ;;
    }

  # Define the view's fields as desired
  dimension: user_id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: nullifzero(${TABLE}.lifetime_orders) ;;
  }

  dimension: lifetime_orders_tiers {
    type: tier
    style: integer
    tiers: [1,2,3,5,10]
    sql: ${lifetime_orders} ;;
  }
  dimension: first_order {
    type: date
    sql: ${TABLE}.first_order ;;
  }
  dimension: latest_order {
    type: date
    sql: ${TABLE}.latest_order ;;
  }
  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }
  dimension: lifetime_revenue_tiers {
    type: tier
    style: integer
    tiers: [0,5,20,50,100,500,1000]
    sql: ${lifetime_revenue} ;;
    value_format: "$#,##0"
  }
  dimension: active_customer {
    description: "Identifies whether a customer is active or not (has purchased from the website within the last 90 days)"
    type: yesno
    sql: datediff(day, ${latest_order}, getdate()) <= 90 ;;
  }
  dimension: days_since_last_order {
    type: number
    sql: datediff(day, ${latest_order}, getdate()) ;;
  }
  dimension: repeat_customer {
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }
  measure: customer_count {
    type: count_distinct
    sql: ${user_id} ;;
  }
  measure:  total_lifetime_orders {
    type: sum
    sql: ${lifetime_orders} ;;
  }
  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }
  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }
  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }
  measure: average_days_since_last_order {
    type: average
    sql: ${days_since_last_order} ;;
  }

}
