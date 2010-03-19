# encoding: utf-8
module Mongoid #:nodoc:
  module Dirty #:nodoc:
    extend ActiveSupport::Concern
    included do
      include ActiveModel::Dirty
      
      alias_method_chain :save,            :dirty
      alias_method_chain :save!,           :dirty
      alias_method_chain :write_attribute, :dirty
      alias_method_chain :reload,          :dirty
    end

    module InstanceMethods
      # Attempts to +save+ the record and clears changed attributes if successful.
      def save_with_dirty(*args) #:nodoc:
        if status = save_without_dirty(*args)
          @previously_changed = changes
          changed_attributes.clear
        end
        status
      end

      # Attempts to <tt>save!</tt> the record and clears changed attributes if successful.
      def save_with_dirty!(*args) #:nodoc:
        save_without_dirty!(*args).tap do
          @previously_changed = changes 
          changed_attributes.clear 
        end
      end

      # <tt>reload</tt> the record and clears changed attributes.
      def reload_with_dirty(*args) #:nodoc:
        reload_without_dirty(*args).tap do
          previously_changed_attributes.clear
          changed_attributes.clear
        end
      end

      private
        # Wrap write_attribute to remember original attribute value.
        def write_attribute_with_dirty(attr, value)
          attr = attr.to_s

          # The attribute already has an unsaved change.
          if changed_attributes.include?(attr)
            old = changed_attributes[attr]
            changed_attributes.delete(attr) unless field_changed?(attr, old, value)
          else
            old = clone_attribute_value(:read_attribute, attr)
            changed_attributes[attr] = old if field_changed?(attr, old, value)
          end

          # Carry on.
          write_attribute_without_dirty(attr, value)
        end

        def field_changed?(attr, old, value)
          if field = fields[attr]
            if field.type.is_a?(Numeric) && (old.nil? || old == 0) && value.blank?
              # For nullable numeric columns, NULL gets stored in database for blank (i.e. '') values.
              # Hence we don't record it as a change if the value changes from nil to ''.
              # If an old value of 0 is set to '' we want this to get changed to nil as otherwise it'll
              # be typecast back to 0 (''.to_i => 0)
              value = nil
            else
              value = field.set(value)
            end
          end

          old != value
        end
    end
  end
end
