# frozen_string_literal: true

# rubocop:disable all
RSpec.describe Rizzy do
  describe ".write" do
    describe "single-value fields" do
      it "writes type field (TY)" do
        reference = Rizzy::Reference.new(type: "JOUR")
        output = Rizzy.write(reference)

        expect(output).to include("TY  - JOUR")
        expect(output).to include("ER  -")
      end

      it "writes database field (DB)" do
        reference = Rizzy::Reference.new(type: "JOUR", database: "PubMed")
        output = Rizzy.write(reference)

        expect(output).to include("DB  - PubMed")
      end

      it "writes id field (ID)" do
        reference = Rizzy::Reference.new(type: "JOUR", id: "12345")
        output = Rizzy.write(reference)

        expect(output).to include("ID  - 12345")
      end

      it "writes doi field (DO)" do
        reference = Rizzy::Reference.new(type: "JOUR", doi: "10.1234/example.doi")
        output = Rizzy.write(reference)

        expect(output).to include("DO  - 10.1234/example.doi")
      end

      it "writes title field using T1 tag" do
        reference = Rizzy::Reference.new(type: "JOUR", title: "A Study of Ruby")
        output = Rizzy.write(reference)

        expect(output).to include("T1  - A Study of Ruby")
        expect(output).not_to include("TI  -")
      end

      it "writes year field using Y1 tag" do
        reference = Rizzy::Reference.new(type: "JOUR", year: "2024")
        output = Rizzy.write(reference)

        expect(output).to include("Y1  - 2024")
        expect(output).not_to include("PY  -")
      end

      it "writes abstract field using N2 tag" do
        reference = Rizzy::Reference.new(type: "JOUR", abstract: "This is the abstract.")
        output = Rizzy.write(reference)

        expect(output).to include("N2  - This is the abstract.")
        expect(output).not_to include("AB  -")
      end

      it "writes type_of_work field (M3)" do
        reference = Rizzy::Reference.new(type: "JOUR", type_of_work: "Dissertation")
        output = Rizzy.write(reference)

        expect(output).to include("M3  - Dissertation")
      end

      it "writes journal_full field (JF)" do
        reference = Rizzy::Reference.new(type: "JOUR", journal_full: "Journal of Ruby Studies")
        output = Rizzy.write(reference)

        expect(output).to include("JF  - Journal of Ruby Studies")
      end

      it "writes volume field (VL)" do
        reference = Rizzy::Reference.new(type: "JOUR", volume: "42")
        output = Rizzy.write(reference)

        expect(output).to include("VL  - 42")
      end

      it "writes issue field (IS)" do
        reference = Rizzy::Reference.new(type: "JOUR", issue: "3")
        output = Rizzy.write(reference)

        expect(output).to include("IS  - 3")
      end

      it "writes start_page field (SP)" do
        reference = Rizzy::Reference.new(type: "JOUR", start_page: "101")
        output = Rizzy.write(reference)

        expect(output).to include("SP  - 101")
      end

      it "writes end_page field (EP)" do
        reference = Rizzy::Reference.new(type: "JOUR", end_page: "150")
        output = Rizzy.write(reference)

        expect(output).to include("EP  - 150")
      end

      it "writes country field (CY)" do
        reference = Rizzy::Reference.new(type: "JOUR", country: "United States")
        output = Rizzy.write(reference)

        expect(output).to include("CY  - United States")
      end

      it "writes isbn field (SN)" do
        reference = Rizzy::Reference.new(type: "JOUR", isbn: "978-0-123456-78-9")
        output = Rizzy.write(reference)

        expect(output).to include("SN  - 978-0-123456-78-9")
      end

      it "writes alternate_journal field (NL)" do
        reference = Rizzy::Reference.new(type: "JOUR", alternate_journal: "J Ruby Stud")
        output = Rizzy.write(reference)

        expect(output).to include("NL  - J Ruby Stud")
      end

      it "writes language field (LA)" do
        reference = Rizzy::Reference.new(type: "JOUR", language: "English")
        output = Rizzy.write(reference)

        expect(output).to include("LA  - English")
      end

      it "writes publication_type field (PT)" do
        reference = Rizzy::Reference.new(type: "JOUR", publication_type: "Journal Article")
        output = Rizzy.write(reference)

        expect(output).to include("PT  - Journal Article")
      end
    end

    describe "multi-value fields" do
      it "writes single author using A1 tag" do
        reference = Rizzy::Reference.new(type: "JOUR", authors: ["Smith, John"])
        output = Rizzy.write(reference)

        expect(output).to include("A1  - Smith, John")
        expect(output).not_to include("AU  -")
      end

      it "writes multiple authors using A1 tag" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          authors: ["Smith, John", "Doe, Jane", "Brown, Bob"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("A1  - Smith, John")
        expect(output).to include("A1  - Doe, Jane")
        expect(output).to include("A1  - Brown, Bob")
      end

      it "writes author identifiers (AI)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          author_identifiers: ["0000-0001-2345-6789", "0000-0002-3456-7890"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("AI  - 0000-0001-2345-6789")
        expect(output).to include("AI  - 0000-0002-3456-7890")
      end

      it "writes secondary authors (A2)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          secondary_authors: ["Editor, First", "Editor, Second"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("A2  - Editor, First")
        expect(output).to include("A2  - Editor, Second")
      end

      it "writes keywords (KW)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          keywords: ["ruby", "programming", "parsing"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("KW  - ruby")
        expect(output).to include("KW  - programming")
        expect(output).to include("KW  - parsing")
      end

      it "writes publishers (PB)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          publishers: ["Academic Press", "University Press"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("PB  - Academic Press")
        expect(output).to include("PB  - University Press")
      end

      it "writes addresses (AD)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          addresses: ["Department of CS, Example University", "Research Institute"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("AD  - Department of CS, Example University")
        expect(output).to include("AD  - Research Institute")
      end

      it "writes miscellaneous_ones (M1)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          miscellaneous_ones: ["Misc data 1", "Misc data 2"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("M1  - Misc data 1")
        expect(output).to include("M1  - Misc data 2")
      end

      it "writes miscellaneous_twos (M2)" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          miscellaneous_twos: ["Additional info 1", "Additional info 2"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("M2  - Additional info 1")
        expect(output).to include("M2  - Additional info 2")
      end

      it "writes urls using L2 tag" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          urls: ["https://example.com/paper1", "https://doi.org/10.1234/example"]
        )
        output = Rizzy.write(reference)

        expect(output).to include("L2  - https://example.com/paper1")
        expect(output).to include("L2  - https://doi.org/10.1234/example")
        expect(output).not_to include("UR  -")
      end
    end

    describe "handling nil and empty values" do
      it "skips nil fields" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          title: "Valid Title",
          abstract: nil
        )
        output = Rizzy.write(reference)

        expect(output).to include("TY  - JOUR")
        expect(output).to include("T1  - Valid Title")
        expect(output).not_to include("N2  -")
      end

      it "skips empty string fields" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          title: "Valid Title",
          abstract: ""
        )
        output = Rizzy.write(reference)

        expect(output).to include("T1  - Valid Title")
        expect(output).not_to include("N2  -")
      end

      it "skips empty array fields" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          title: "Valid Title",
          authors: []
        )
        output = Rizzy.write(reference)

        expect(output).to include("T1  - Valid Title")
        expect(output).not_to include("A1  -")
      end
    end

    describe "writing multiple references" do
      it "writes multiple references separated by ER" do
        ref1 = Rizzy::Reference.new(type: "JOUR", title: "First Article")
        ref2 = Rizzy::Reference.new(type: "BOOK", title: "Second Book")

        output = Rizzy.write([ref1, ref2])

        expect(output.scan(/ER  -/).length).to eq(2)
        expect(output).to include("TY  - JOUR")
        expect(output).to include("T1  - First Article")
        expect(output).to include("TY  - BOOK")
        expect(output).to include("T1  - Second Book")
      end

      it "accepts a single reference (not in array)" do
        reference = Rizzy::Reference.new(type: "JOUR", title: "Single Article")
        output = Rizzy.write(reference)

        expect(output).to include("TY  - JOUR")
        expect(output).to include("T1  - Single Article")
        expect(output.scan(/ER  -/).length).to eq(1)
      end
    end

    describe "complete reference" do
      it "writes a complex reference with all field types" do
        reference = Rizzy::Reference.new(
          type: "JOUR",
          database: "PubMed",
          id: "12345",
          doi: "10.1234/example",
          title: "Advanced Ruby Programming",
          year: "2024",
          abstract: "This paper explores Ruby.",
          type_of_work: "Research Article",
          journal_full: "Journal of Ruby",
          volume: "42",
          issue: "3",
          start_page: "101",
          end_page: "150",
          country: "USA",
          isbn: "1234-5678",
          alternate_journal: "J Ruby",
          language: "English",
          publication_type: "Journal Article",
          authors: ["Smith, John", "Doe, Jane"],
          author_identifiers: ["0000-0001-2345-6789"],
          secondary_authors: ["Editor, Chief"],
          keywords: ["ruby", "programming"],
          publishers: ["Academic Press"],
          addresses: ["New York, NY"],
          miscellaneous_ones: ["Misc 1"],
          miscellaneous_twos: ["Misc 2"],
          urls: ["https://example.com"]
        )

        output = Rizzy.write(reference)

        # Verify all fields are present
        expect(output).to include("TY  - JOUR")
        expect(output).to include("DB  - PubMed")
        expect(output).to include("ID  - 12345")
        expect(output).to include("DO  - 10.1234/example")
        expect(output).to include("T1  - Advanced Ruby Programming")
        expect(output).to include("Y1  - 2024")
        expect(output).to include("N2  - This paper explores Ruby.")
        expect(output).to include("M3  - Research Article")
        expect(output).to include("JF  - Journal of Ruby")
        expect(output).to include("VL  - 42")
        expect(output).to include("IS  - 3")
        expect(output).to include("SP  - 101")
        expect(output).to include("EP  - 150")
        expect(output).to include("CY  - USA")
        expect(output).to include("SN  - 1234-5678")
        expect(output).to include("NL  - J Ruby")
        expect(output).to include("LA  - English")
        expect(output).to include("PT  - Journal Article")
        expect(output).to include("A1  - Smith, John")
        expect(output).to include("A1  - Doe, Jane")
        expect(output).to include("AI  - 0000-0001-2345-6789")
        expect(output).to include("A2  - Editor, Chief")
        expect(output).to include("KW  - ruby")
        expect(output).to include("KW  - programming")
        expect(output).to include("PB  - Academic Press")
        expect(output).to include("AD  - New York, NY")
        expect(output).to include("M1  - Misc 1")
        expect(output).to include("M2  - Misc 2")
        expect(output).to include("L2  - https://example.com")
        expect(output).to include("ER  -")
      end
    end

    describe "idempotency" do
      it "produces identical Reference when parse -> write -> parse" do
        # Create a reference with various fields
        original = Rizzy::Reference.new(
          type: "JOUR",
          title: "Test Article",
          year: "2024",
          abstract: "Test abstract.",
          authors: ["Smith, John", "Doe, Jane"],
          keywords: ["ruby", "testing"]
        )

        # Write to RIS format
        ris_output = Rizzy.write(original)

        # Parse back
        parsed = Rizzy.parse(ris_output)

        # Should have exactly one reference
        expect(parsed.length).to eq(1)

        # Compare all fields
        reparsed = parsed[0]
        expect(reparsed.type).to eq(original.type)
        expect(reparsed.title).to eq(original.title)
        expect(reparsed.year).to eq(original.year)
        expect(reparsed.abstract).to eq(original.abstract)
        expect(reparsed.authors).to eq(original.authors)
        expect(reparsed.keywords).to eq(original.keywords)
      end

      it "maintains all fields through parse -> write -> parse cycle" do
        original = Rizzy::Reference.new(
          type: "BOOK",
          database: "Library",
          id: "ABC123",
          doi: "10.5555/12345678",
          title: "Ruby Programming Guide",
          year: "2023",
          abstract: "A comprehensive guide to Ruby programming.",
          type_of_work: "Reference Book",
          journal_full: "Technical Books",
          volume: "1",
          issue: "2",
          start_page: "1",
          end_page: "500",
          country: "United Kingdom",
          isbn: "978-0-123456-78-9",
          alternate_journal: "Tech Books",
          language: "English",
          publication_type: "Book",
          authors: ["Author, Primary", "Author, Secondary"],
          author_identifiers: ["0000-0001-1111-1111"],
          secondary_authors: ["Editor, Chief"],
          keywords: ["ruby", "programming", "reference"],
          publishers: ["Tech Publishers"],
          addresses: ["London, UK"],
          miscellaneous_ones: ["Extra info 1"],
          miscellaneous_twos: ["Extra info 2"],
          urls: ["https://example.com/book"]
        )

        ris_output = Rizzy.write(original)
        reparsed = Rizzy.parse(ris_output)[0]

        # Compare all fields
        expect(reparsed.type).to eq(original.type)
        expect(reparsed.database).to eq(original.database)
        expect(reparsed.id).to eq(original.id)
        expect(reparsed.doi).to eq(original.doi)
        expect(reparsed.title).to eq(original.title)
        expect(reparsed.year).to eq(original.year)
        expect(reparsed.abstract).to eq(original.abstract)
        expect(reparsed.type_of_work).to eq(original.type_of_work)
        expect(reparsed.journal_full).to eq(original.journal_full)
        expect(reparsed.volume).to eq(original.volume)
        expect(reparsed.issue).to eq(original.issue)
        expect(reparsed.start_page).to eq(original.start_page)
        expect(reparsed.end_page).to eq(original.end_page)
        expect(reparsed.country).to eq(original.country)
        expect(reparsed.isbn).to eq(original.isbn)
        expect(reparsed.alternate_journal).to eq(original.alternate_journal)
        expect(reparsed.language).to eq(original.language)
        expect(reparsed.publication_type).to eq(original.publication_type)
        expect(reparsed.authors).to eq(original.authors)
        expect(reparsed.author_identifiers).to eq(original.author_identifiers)
        expect(reparsed.secondary_authors).to eq(original.secondary_authors)
        expect(reparsed.keywords).to eq(original.keywords)
        expect(reparsed.publishers).to eq(original.publishers)
        expect(reparsed.addresses).to eq(original.addresses)
        expect(reparsed.miscellaneous_ones).to eq(original.miscellaneous_ones)
        expect(reparsed.miscellaneous_twos).to eq(original.miscellaneous_twos)
        expect(reparsed.urls).to eq(original.urls)
      end

      it "handles multiple references through round-trip" do
        ref1 = Rizzy::Reference.new(
          type: "JOUR",
          title: "First Article",
          authors: ["Smith, A"],
          keywords: ["test1"]
        )
        ref2 = Rizzy::Reference.new(
          type: "BOOK",
          title: "Second Book",
          authors: ["Jones, B"],
          keywords: ["test2"]
        )

        originals = [ref1, ref2]
        ris_output = Rizzy.write(originals)
        reparsed = Rizzy.parse(ris_output)

        expect(reparsed.length).to eq(2)

        expect(reparsed[0].type).to eq(ref1.type)
        expect(reparsed[0].title).to eq(ref1.title)
        expect(reparsed[0].authors).to eq(ref1.authors)
        expect(reparsed[0].keywords).to eq(ref1.keywords)

        expect(reparsed[1].type).to eq(ref2.type)
        expect(reparsed[1].title).to eq(ref2.title)
        expect(reparsed[1].authors).to eq(ref2.authors)
        expect(reparsed[1].keywords).to eq(ref2.keywords)
      end

      it "handles empty and nil fields correctly in round-trip" do
        original = Rizzy::Reference.new(
          type: "JOUR",
          title: "Article with sparse data",
          abstract: nil,
          authors: ["Single, Author"],
          keywords: []
        )

        ris_output = Rizzy.write(original)
        reparsed = Rizzy.parse(ris_output)[0]

        expect(reparsed.type).to eq(original.type)
        expect(reparsed.title).to eq(original.title)
        expect(reparsed.abstract).to be_nil
        expect(reparsed.authors).to eq(original.authors)
        # Empty arrays don't get written, so they come back as empty
        expect(reparsed.keywords).to eq nil
      end
    end
  end
end
