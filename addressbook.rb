require 'citrus'

class Contact
  attr_accessor :name, :address, :phone
end

class AddressBook
  def contacts
    @contacts ||= []
  end
end

module InnerText
  def value
    matches[1].text
  end
end

# Load the grammar file.
Citrus.load(File.expand_path('../addressbook', __FILE__))

if $0 == __FILE__
  require 'test/unit'

  class AddressBookTest < Test::Unit::TestCase
    def setup
      @sample_data ||= DATA.read
    end

    attr_reader :sample_data

    def test_contact
      match = AddressBook::Grammar.parse(<<'XML', :root => :contact)
<contact>
  <name>Michael Jackson</name>
  <address>5225 Figueroa Mountain Rd., Los Olivos, CA 93441</address>
  <phone>(555) 555-5555</phone>
</contact>
XML

      assert(match)

      # The value of a contact match should return a new contact object.
      contact = match.value
      assert_instance_of(Contact, contact)

      # Test to make sure all the contact properties were set correctly.
      assert_equal('Michael Jackson', contact.name)
      assert_equal('5225 Figueroa Mountain Rd., Los Olivos, CA 93441', contact.address)
      assert_equal('(555) 555-5555', contact.phone)
    end

    def test_addressbook
      match = AddressBook::Grammar.parse(sample_data)
      assert(match)

      book = match.value

      assert_instance_of(AddressBook, book)
      # Our sample data contains 3 contacts.
      assert_equal(3, book.contacts.length)

      book.contacts.each do |c|
        assert_instance_of(Contact, c)
      end
    end
  end
end

__END__
<contacts>
  <contact>
    <name>Michael Jackson</name>
    <address>5225 Figueroa Mountain Rd., Los Olivos, CA 93441</address>
    <phone>(555) 555-5555</phone>
  </contact>
  <contact>
    <name>James Dean</name>
    <address>10426 110 St., Jamaica, NY 11416</address>
    <phone>(444) 444-4444</phone>
  </contact>
  <contact>
    <name>Elvis Presley</name>
    <address>3734 Elvis Presley Blvd., Memphis, TN 38116</address>
    <phone>(333) 333-3333</phone>
  </contact>
</contacts>
