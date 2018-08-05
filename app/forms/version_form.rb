class VersionForm < Reform::Form

  property :id, writeable: false
  property :delete, virtual: true
  property :document
  property :document_cache

end
