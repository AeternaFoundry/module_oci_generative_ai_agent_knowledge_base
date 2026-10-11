variable "generative_ai_agent_knowledge_bases" {
  description = <<EOT
Map of generative_ai_agent_knowledge_bases, attributes below
Required:
    - compartment_id
    - index_config (block):
        - cluster_id (optional)
        - database_connection (optional, block):
            - connection_id (required)
            - connection_type (required)
        - database_functions (optional, block):
            - name (optional)
        - index_config_type (required)
        - indexes (optional, block):
            - name (optional)
            - schema (optional, block):
                - body_key (optional)
                - embedding_body_key (optional)
                - title_key (optional)
                - url_key (optional)
        - secret_detail (optional, block):
            - client_id (optional)
            - idcs_url (optional)
            - scope_url (optional)
            - type (required)
            - vault_secret_id (required)
        - should_enable_hybrid_search (optional)
Optional:
    - defined_tags
    - description
    - display_name
    - freeform_tags
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id = string
    defined_tags   = optional(map(string))
    description    = optional(string)
    display_name   = optional(string)
    freeform_tags  = optional(map(string))
    index_config = object({
      cluster_id = optional(string)
      database_connection = optional(object({
        connection_id   = string
        connection_type = string
      }))
      database_functions = optional(list(object({
        name = optional(string)
      })))
      index_config_type = string
      indexes = optional(list(object({
        name = optional(string)
        schema = optional(object({
          body_key           = optional(string)
          embedding_body_key = optional(string)
          title_key          = optional(string)
          url_key            = optional(string)
        }))
      })))
      secret_detail = optional(object({
        client_id       = optional(string)
        idcs_url        = optional(string)
        scope_url       = optional(string)
        type            = string
        vault_secret_id = string
      }))
      should_enable_hybrid_search = optional(bool)
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.generative_ai_agent_knowledge_bases : (
        contains([for v in ["DEFAULT_INDEX_CONFIG", "OCI_DATABASE_CONFIG", "OCI_OPEN_SEARCH_INDEX_CONFIG"] : lower(v)], lower(v.index_config.index_config_type))
      )
    ])
    error_message = "must be one of: \"DEFAULT_INDEX_CONFIG\", \"OCI_DATABASE_CONFIG\", \"OCI_OPEN_SEARCH_INDEX_CONFIG\""
  }
  validation {
    condition = alltrue([
      for k, v in var.generative_ai_agent_knowledge_bases : (
        v.index_config.database_connection == null || (contains([for v in ["DATABASE_TOOL_CONNECTION"] : lower(v)], lower(v.index_config.database_connection.connection_type)))
      )
    ])
    error_message = "must be one of: \"DATABASE_TOOL_CONNECTION\""
  }
  validation {
    condition = alltrue([
      for k, v in var.generative_ai_agent_knowledge_bases : (
        v.index_config.secret_detail == null || (contains([for v in ["BASIC_AUTH_SECRET", "IDCS_SECRET"] : lower(v)], lower(v.index_config.secret_detail.type)))
      )
    ])
    error_message = "must be one of: \"BASIC_AUTH_SECRET\", \"IDCS_SECRET\""
  }
}

