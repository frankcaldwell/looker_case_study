view: dt_order_facts {
  derived_table: {
      explore_source: order_patterns {
        column: user_id {}
        column: created_at {}
        column: days_between_orders {}
        column: min_days_between_orders {}
        derived_column: min_repurchase{sql: min(min_days_between_orders) over (partition by user_id
                                                 order by min_days_between_orders);;}
      }
    }
    dimension: user_id {
      type: number
    }
    dimension: created_at {
      type: date_time
    }
    dimension: days_between_orders {
      type: number
    }
    dimension: min_days_between_orders {
      type: number
    }
    dimension: min_repurchase {
      type: number

    }

  }
