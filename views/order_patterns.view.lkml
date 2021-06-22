view: order_patterns {
  derived_table: {
    sql: select oi.user_id,
       oi.order_id,
       oi.created_at,
       dense_rank() over (partition by oi.user_id order by oi.created_at) as order_sequence,
       lag(oi.created_at) over (partition by oi.user_id order by oi.created_at) as previous_order,
       count(oi.order_id) over (partition by oi.user_id) as number_of_orders

  from (select distinct user_id,
               order_id,
               created_at
          from order_items) oi;;
  }
  dimension: order_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: created_at {
    type: date_time
    sql: ${TABLE}.created_at ;;
  }
  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }
  dimension: previous_order {
    type: date_time
    sql: ${TABLE}.previous_order ;;
  }
  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }
    dimension: days_between_orders {
    type:  number
    sql: datediff(day,${previous_order},${created_at}) ;;
  }
  dimension: is_first_purchase {
    type: yesno
    sql: ${order_sequence} = 1 ;;
  }
  measure: avg_days_between_orders {
    type: average
    sql: ${days_between_orders} ;;
  }
  dimension: has_subsequent_order {
    type: yesno
    sql: ${number_of_orders} > 1 ;;
  }
  measure: min_days_between_orders {
    type: min
    sql:  ${days_between_orders};;
  }
  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

}
