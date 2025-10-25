module Rizzy
  Reference = Struct.new(
    :type,                    # TY
    :database,                # DB
    :id,                      # ID
    :doi,                     # DO
    :title,                   # T1, TI
    :year,                    # Y1, PY
    :abstract,                # N2, AB
    :type_of_work,            # M3
    :journal_full,            # JF
    :volume,                  # VL
    :issue,                   # IS
    :start_page,              # SP
    :end_page,                # EP
    :country,                 # CY
    :isbn,                    # SN
    :alternate_journal,       # NL
    :language,                # LA
    :publication_type,        # PT
    :authors,                 # A1, AU
    :author_identifiers,      # AI
    :secondary_authors,       # A2
    :keywords,                # KW
    :publishers,              # PB
    :addresses,               # AD
    :miscellaneous_ones,      # M1
    :miscellaneous_twos,      # M2
    :urls                     # L2, UR
  )
end
