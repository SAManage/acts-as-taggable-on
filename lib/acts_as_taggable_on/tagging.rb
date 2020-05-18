module ActsAsTaggableOn
  class Tagging < ::ActiveRecord::Base #:nodoc:
    self.table_name = ActsAsTaggableOn.taggings_table

    DEFAULT_CONTEXT = 'tags'
    belongs_to :tag, class_name: '::ActsAsTaggableOn::Tag'
    belongs_to :taggable, polymorphic: true

    belongs_to :tagger, {polymorphic: true}.tap {|o| o.merge!(optional: true) }

    scope :owned_by, ->(owner) { where(tagger: owner) }
    scope :not_owned, -> { where(tagger_id: nil, tagger_type: nil) }

    scope :by_contexts, ->(contexts) { where(context: (contexts || DEFAULT_CONTEXT)) }
    scope :by_context, ->(context = DEFAULT_CONTEXT) { by_contexts(context.to_s) }

    validates_presence_of :context
    validates_presence_of :tag_id

    validates_uniqueness_of :tag_id, scope: [:taggable_type, :taggable_id, :context, :tagger_id, :tagger_type]
  end
end
