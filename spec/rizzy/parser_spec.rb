# frozen_string_literal: true

# rubocop:disable all
RSpec.describe Rizzy do
  describe ".parse" do
    # Basic parsing functionality - ensures the parser can handle a simple entry
    context "with a minimal valid entry" do
      it "parses a single entry with one field" do
        # Using inline string for simple test case
        # The ER  - delimiter marks the end of a RIS entry
        content = "TY  - JOUR\nER  -"
        references = Rizzy.parse(content)

        expect(references).to be_an(Array)
        expect(references.length).to eq(1)
        expect(references[0]).to be_a(Rizzy::Reference)
        expect(references[0].type).to eq("JOUR")
      end
    end

    # Test parsing multiple entries in a single file
    context "with multiple entries" do
      it "splits and parses multiple references" do
        # Multi-line string using heredoc syntax
        # Each entry is separated by ER  -
        content = <<~RIS
          TY  - JOUR
          TI  - First Article
          ER  -
          TY  - BOOK
          TI  - Second Book
          ER  -
        RIS

        references = Rizzy.parse(content)
        expect(references.length).to eq(2)
        expect(references[0].type).to eq("JOUR")
        expect(references[0].title).to eq("First Article")
        expect(references[1].type).to eq("BOOK")
        expect(references[1].title).to eq("Second Book")
      end
    end

    # Testing single-value (scalar) fields
    describe "single-value fields" do
      it "parses type field (TY)" do
        content = "TY  - JOUR\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.type).to eq("JOUR")
      end

      it "parses database field (DB)" do
        content = "TY  - JOUR\nDB  - PubMed\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.database).to eq("PubMed")
      end

      it "parses id field (ID)" do
        content = "TY  - JOUR\nID  - 12345\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.id).to eq("12345")
      end

      it "parses doi field (DO)" do
        content = "TY  - JOUR\nDO  - 10.1234/example.doi\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.doi).to eq("10.1234/example.doi")
      end

      it "parses title field (TI)" do
        content = "TY  - JOUR\nTI  - A Study of Ruby Parsing\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("A Study of Ruby Parsing")
      end

      it "parses year field (PY)" do
        content = "TY  - JOUR\nPY  - 2024\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.year).to eq("2024")
      end

      it "parses abstract field (AB)" do
        content = "TY  - JOUR\nAB  - This is the abstract of the paper.\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.abstract).to eq("This is the abstract of the paper.")
      end

      it "parses type_of_work field (M3)" do
        content = "TY  - JOUR\nM3  - Dissertation\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.type_of_work).to eq("Dissertation")
      end

      it "parses journal_full field (JF)" do
        content = "TY  - JOUR\nJF  - Journal of Ruby Studies\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.journal_full).to eq("Journal of Ruby Studies")
      end

      it "parses volume field (VL)" do
        content = "TY  - JOUR\nVL  - 42\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.volume).to eq("42")
      end

      it "parses issue field (IS)" do
        content = "TY  - JOUR\nIS  - 3\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.issue).to eq("3")
      end

      it "parses start_page field (SP)" do
        content = "TY  - JOUR\nSP  - 101\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.start_page).to eq("101")
      end

      it "parses end_page field (EP)" do
        content = "TY  - JOUR\nEP  - 150\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.end_page).to eq("150")
      end

      it "parses country field (CY)" do
        content = "TY  - JOUR\nCY  - United States\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.country).to eq("United States")
      end

      it "parses isbn field (SN)" do
        content = "TY  - JOUR\nSN  - 978-0-123456-78-9\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.isbn).to eq("978-0-123456-78-9")
      end

      it "parses alternate_journal field (NL)" do
        content = "TY  - JOUR\nNL  - J Ruby Stud\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.alternate_journal).to eq("J Ruby Stud")
      end

      it "parses language field (LA)" do
        content = "TY  - JOUR\nLA  - English\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.language).to eq("English")
      end

      it "parses publication_type field (PT)" do
        content = "TY  - JOUR\nPT  - Journal Article\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.publication_type).to eq("Journal Article")
      end
    end

    # Testing multi-value (array) fields
    # These fields can appear multiple times and are collected into arrays
    describe "multi-value fields" do
      it "parses single author (AU)" do
        content = "TY  - JOUR\nAU  - Smith, John\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.authors).to eq(["Smith, John"])
      end

      it "parses multiple authors (AU)" do
        # Multiple AU tags accumulate into the authors array
        content = <<~RIS
          TY  - JOUR
          AU  - Smith, John
          AU  - Doe, Jane
          AU  - Brown, Bob
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.authors).to eq(["Smith, John", "Doe, Jane", "Brown, Bob"])
      end

      it "parses author identifiers (AI)" do
        content = <<~RIS
          TY  - JOUR
          AI  - 0000-0001-2345-6789
          AI  - 0000-0002-3456-7890
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.author_identifiers).to eq(%w[0000-0001-2345-6789 0000-0002-3456-7890])
      end

      it "parses secondary authors (A2)" do
        content = <<~RIS
          TY  - JOUR
          A2  - Editor, First
          A2  - Editor, Second
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.secondary_authors).to eq(["Editor, First", "Editor, Second"])
      end

      it "parses single keyword (KW)" do
        content = "TY  - JOUR\nKW  - ruby\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.keywords).to eq(["ruby"])
      end

      it "parses multiple keywords (KW)" do
        # Keywords are commonly used in academic references
        content = <<~RIS
          TY  - JOUR
          KW  - ruby
          KW  - programming
          KW  - parsing
          KW  - RIS format
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.keywords).to eq(["ruby", "programming", "parsing", "RIS format"])
      end

      it "parses publishers (PB)" do
        content = <<~RIS
          TY  - JOUR
          PB  - Academic Press
          PB  - University Press
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.publishers).to eq(["Academic Press", "University Press"])
      end

      it "parses addresses (AD)" do
        content = <<~RIS
          TY  - JOUR
          AD  - Department of Computer Science, Example University
          AD  - Research Institute, Another Location
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.addresses).to eq([
                                            "Department of Computer Science, Example University",
                                            "Research Institute, Another Location"
                                          ])
      end

      it "parses miscellaneous_ones (M1)" do
        content = <<~RIS
          TY  - JOUR
          M1  - Misc data 1
          M1  - Misc data 2
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.miscellaneous_ones).to eq(["Misc data 1", "Misc data 2"])
      end

      it "parses miscellaneous_twos (M2)" do
        content = <<~RIS
          TY  - JOUR
          M2  - Additional info 1
          M2  - Additional info 2
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.miscellaneous_twos).to eq(["Additional info 1", "Additional info 2"])
      end

      it "parses urls (UR)" do
        content = <<~RIS
          TY  - JOUR
          UR  - https://example.com/paper1
          UR  - https://doi.org/10.1234/example
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.urls).to eq([
                                       "https://example.com/paper1",
                                       "https://doi.org/10.1234/example"
                                     ])
      end
    end

    # Testing field aliases - some fields have multiple tag names
    describe "field aliases" do
      it "parses T1 as title (alias for TI)" do
        content = "TY  - JOUR\nT1  - Title via T1 tag\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Title via T1 tag")
      end

      it "parses TI as title" do
        content = "TY  - JOUR\nTI  - Title via TI tag\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Title via TI tag")
      end

      it "parses Y1 as year (alias for PY)" do
        content = "TY  - JOUR\nY1  - 2023\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.year).to eq("2023")
      end

      it "parses PY as year" do
        content = "TY  - JOUR\nPY  - 2024\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.year).to eq("2024")
      end

      it "parses N2 as abstract (alias for AB)" do
        content = "TY  - JOUR\nN2  - Abstract via N2 tag\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.abstract).to eq("Abstract via N2 tag")
      end

      it "parses AB as abstract" do
        content = "TY  - JOUR\nAB  - Abstract via AB tag\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.abstract).to eq("Abstract via AB tag")
      end

      it "parses A1 as author (alias for AU)" do
        content = <<~RIS
          TY  - JOUR
          A1  - First, Author
          A1  - Second, Author
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.authors).to eq(["First, Author", "Second, Author"])
      end

      it "parses AU as author" do
        content = <<~RIS
          TY  - JOUR
          AU  - First, Author
          AU  - Second, Author
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.authors).to eq(["First, Author", "Second, Author"])
      end

      it "parses L2 as url (alias for UR)" do
        content = "TY  - JOUR\nL2  - https://example.com\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.urls).to eq(["https://example.com"])
      end

      it "parses UR as url" do
        content = "TY  - JOUR\nUR  - https://example.com\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.urls).to eq(["https://example.com"])
      end
    end

    # Edge cases and error handling
    describe "edge cases" do
      it "handles empty string" do
        content = ""
        references = Rizzy.parse(content)
        # Empty string results in one empty entry
        expect(references).to be_an(Array)
      end

      it "handles entry with no fields" do
        content = "ER  -"
        references = Rizzy.parse(content)
        expect(references.length).to eq(0)
      end

      it "handles whitespace in values" do
        # The parser should strip trailing whitespace
        content = "TY  - JOUR\nTI  - Title with spaces   \nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Title with spaces")
      end

      it "handles leading whitespace in values" do
        content = "TY  - JOUR\nTI  -    Title with leading spaces\nER  -"
        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Title with leading spaces")
      end

      it "ignores lines without proper delimiter" do
        # Lines that don't have the "  - " delimiter are skipped
        content = <<~RIS
          TY  - JOUR
          TI  - Valid Title
          This line has no delimiter
          AU  - Valid, Author
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Valid Title")
        expect(reference.authors).to eq(["Valid, Author"])
      end

      it "handles unknown tags gracefully" do
        # Unknown tags are simply ignored by the parser
        content = <<~RIS
          TY  - JOUR
          TI  - Known Title
          XX  - Unknown Tag
          AU  - Known, Author
          ER  -
        RIS

        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Known Title")
        expect(reference.authors).to eq(["Known, Author"])
      end

      it "handles empty field values" do
        # Fields with empty values after the delimiter
        content = "TY  - JOUR\nTI  - \nER  -"
        reference = Rizzy.parse(content)[0]
        # Empty string after stripping
        expect(reference.title).to eq("")
      end
    end

    # Testing complex realistic entries
    describe "complex realistic entries" do
      it "parses a complete journal article entry" do
        # A typical journal article with many fields
        content = <<~RIS
          TY  - JOUR
          DB  - PubMed
          ID  - 12345678
          T1  - Advanced Ruby Programming Techniques for Scientific Computing
          A1  - Smith, John A.
          A1  - Doe, Jane B.
          A1  - Johnson, Robert C.
          Y1  - 2024/01/15
          N2  - This paper explores advanced techniques in Ruby programming specifically designed for scientific computing applications. We demonstrate performance optimizations and best practices.
          KW  - ruby
          KW  - scientific computing
          KW  - performance optimization
          KW  - programming languages
          JF  - Journal of Computational Sciences
          VL  - 45
          IS  - 3
          SP  - 234
          EP  - 256
          DO  - 10.1234/jcs.2024.012345
          PB  - Academic Press
          SN  - 1234-5678
          UR  - https://doi.org/10.1234/jcs.2024.012345
          UR  - https://example.com/fulltext
          LA  - English
          ER  -
        RIS

        references = Rizzy.parse(content)
        expect(references.length).to eq(1)

        ref = references[0]
        expect(ref.type).to eq("JOUR")
        expect(ref.database).to eq("PubMed")
        expect(ref.id).to eq("12345678")
        expect(ref.title).to eq("Advanced Ruby Programming Techniques for Scientific Computing")
        expect(ref.authors).to eq(["Smith, John A.", "Doe, Jane B.", "Johnson, Robert C."])
        expect(ref.year).to eq("2024/01/15")
        expect(ref.abstract).to include("advanced techniques in Ruby programming")
        expect(ref.keywords).to eq(["ruby", "scientific computing", "performance optimization",
                                    "programming languages"])
        expect(ref.journal_full).to eq("Journal of Computational Sciences")
        expect(ref.volume).to eq("45")
        expect(ref.issue).to eq("3")
        expect(ref.start_page).to eq("234")
        expect(ref.end_page).to eq("256")
        expect(ref.doi).to eq("10.1234/jcs.2024.012345")
        expect(ref.publishers).to eq(["Academic Press"])
        expect(ref.isbn).to eq("1234-5678")
        expect(ref.urls).to eq([
                                 "https://doi.org/10.1234/jcs.2024.012345",
                                 "https://example.com/fulltext"
                               ])
        expect(ref.language).to eq("English")
      end

      it "parses a book entry with multiple publishers and addresses" do
        content = <<~RIS
          TY  - BOOK
          T1  - The Ruby Programming Language: A Comprehensive Guide
          A1  - Author, Primary
          A2  - Editor, Chief
          A2  - Editor, Associate
          PY  - 2023
          PB  - Technical Books Inc.
          PB  - International Publishers
          AD  - New York, NY
          AD  - London, UK
          SN  - 978-0-123456-78-9
          M3  - Reference Book
          KW  - ruby
          KW  - programming
          KW  - reference
          ER  -
        RIS

        ref = Rizzy.parse(content)[0]
        expect(ref.type).to eq("BOOK")
        expect(ref.title).to eq("The Ruby Programming Language: A Comprehensive Guide")
        expect(ref.authors).to eq(["Author, Primary"])
        expect(ref.secondary_authors).to eq(["Editor, Chief", "Editor, Associate"])
        expect(ref.year).to eq("2023")
        expect(ref.publishers).to eq(["Technical Books Inc.", "International Publishers"])
        expect(ref.addresses).to eq(["New York, NY", "London, UK"])
        expect(ref.isbn).to eq("978-0-123456-78-9")
        expect(ref.type_of_work).to eq("Reference Book")
        expect(ref.keywords).to eq(%w[ruby programming reference])
      end
    end

    # Testing encoding handling
    describe "encoding" do
      it "converts non-UTF-8 encoded content to UTF-8" do
        # Create a string with ASCII-8BIT encoding (simulating file read)
        content = "TY  - JOUR\nER  -".dup.force_encoding("ASCII-8BIT")
        expect(content.encoding.name).to eq("ASCII-8BIT")

        references = Rizzy.parse(content)
        ref = references[0]

        # The parsed values should be UTF-8 encoded
        expect(ref.type.encoding.name).to eq("UTF-8")
      end

      it "handles already UTF-8 encoded content" do
        # Content that's already UTF-8 should work fine
        content = "TY  - JOUR\nTI  - Título en español\nER  -"
        expect(content.encoding.name).to eq("UTF-8")

        reference = Rizzy.parse(content)[0]
        expect(reference.title).to eq("Título en español")
        expect(reference.title.encoding.name).to eq("UTF-8")
      end
    end
  end
end
