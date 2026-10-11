resource "oci_generative_ai_agent_knowledge_base" "generative_ai_agent_knowledge_bases" {
  for_each = var.generative_ai_agent_knowledge_bases

  compartment_id = each.value.compartment_id
  defined_tags   = each.value.defined_tags
  description    = each.value.description
  display_name   = each.value.display_name
  freeform_tags  = each.value.freeform_tags

  index_config {
    cluster_id = each.value.index_config.cluster_id
    dynamic "database_connection" {
      for_each = each.value.index_config.database_connection != null ? [each.value.index_config.database_connection] : []
      content {
        connection_id   = database_connection.value.connection_id
        connection_type = database_connection.value.connection_type
      }
    }
    dynamic "database_functions" {
      for_each = each.value.index_config.database_functions != null ? each.value.index_config.database_functions : []
      content {
        name = database_functions.value.name
      }
    }
    index_config_type = each.value.index_config.index_config_type
    dynamic "indexes" {
      for_each = each.value.index_config.indexes != null ? each.value.index_config.indexes : []
      content {
        name = indexes.value.name
        dynamic "schema" {
          for_each = indexes.value.schema != null ? [indexes.value.schema] : []
          content {
            body_key           = schema.value.body_key
            embedding_body_key = schema.value.embedding_body_key
            title_key          = schema.value.title_key
            url_key            = schema.value.url_key
          }
        }
      }
    }
    dynamic "secret_detail" {
      for_each = each.value.index_config.secret_detail != null ? [each.value.index_config.secret_detail] : []
      content {
        client_id       = secret_detail.value.client_id
        idcs_url        = secret_detail.value.idcs_url
        scope_url       = secret_detail.value.scope_url
        type            = secret_detail.value.type
        vault_secret_id = secret_detail.value.vault_secret_id
      }
    }
    should_enable_hybrid_search = each.value.index_config.should_enable_hybrid_search
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

