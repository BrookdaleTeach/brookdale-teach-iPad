//
//  ClassDefinitions.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/11/13.
//
//

// Delimiter
#define kContent_Delimiter                 @"$$"

// Cell Keys
#define FIRST_INDEX_KEY 0
#define SECOND_INDEX_KEY 100
#define THIRD_INDEX_KEY 200
#define FOURTH_INDEX_KEY 300

// Databases
#define kStudents_Database                 @"students.sql"
#define kMath_Database                     @"math.sql"
#define kReading_Database                  @"reading.sql"
#define kWriting_Database                  @"writing.sql"
#define kBehavioral_Database               @"behavioral.sql"

#define kColumn_formative                  @"formative"
#define kColumn_standard                   @"standardized"

// Math Class Definitions
#define kMath_Key                          1

#define kTable_math_formative              @"math_tests_formative"
#define kTable_math_standard               @"math_tests_standard"

#define kTable_math_behaviors              @"math_behaviors"
#define kTable_math_skills                 @"math_skills"

#define kInsert_math_behaviors             @"INSERT INTO math_behaviors( \
                                uid,                     \
                                student_actively_engaged,\
                                student_collaborates,    \
                                student_solves_problems, \
                                student_works_independently, \
                                student_makes_estimates, \
                                student_explains,        \
                                student_strategizes, \
                                student_presents_solution, \
                                student_participates, \
                                student_completes_assignments, \
                                student_completes_homework, \
                                student_understands_mistakes) \
                                VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"

#define kInsert_math_skills                @"INSERT INTO math_skills( \
                                uid, \
                                student_adds, \
                                student_subtracts, \
                                student_multiplies, \
                                student_divides, \
                                student_fractions, \
                                student_tells_time, \
                                student_counts_money, \
                                student_understands_geometry, \
                                student_understands_measurement, \
                                student_understands_algebra) \
                                VALUES(?,?,?,?,?,?,?,?,?,?,?)"

#define kObjects_math_behaviors            @"student_actively_engaged,   \
                                student_collaborates,       \
                                student_solves_problems,    \
                                student_works_independently, \
                                student_makes_estimates,    \
                                student_explains,        \
                                student_strategizes,        \
                                student_presents_solution,  \
                                student_participates,       \
                                student_completes_assignments, \
                                student_completes_homework, \
                                student_understands_mistakes"

#define kObjects_math_skills               @"student_adds, \
                                student_subtracts, \
                                student_multiplies, \
                                student_divides, \
                                student_fractions, \
                                student_tells_time, \
                                student_counts_money, \
                                student_understands_geometry, \
                                student_understands_measurement, \
                                student_understands_algebra"

#define kNOO_math_behaviors                13
#define kNOO_math_skills                   11

// Reading Class Definitions
#define kReading_Key                       2

#define kTable_reading_formative              @"reading_tests_formative"
#define kTable_reading_standard               @"reading_tests_standard"

#define kTable_reading_strategies          @"reading_strategies"
#define kTable_reading_decoding            @"reading_decoding"
#define kTable_reading_fluency             @"reading_fluency"

#define kInsert_reading_strategies         @"INSERT INTO reading_strategies( \
                                    uid, \
                                    student_identify_elements, \
                                    student_inferences, \
                                    student_predicts, \
                                    student_sequences, \
                                    student_text_self, \
                                    student_text_text, \
                                    student_text_world, \
                                    student_identify_main, \
                                    student_identify_detail) \
                                    VALUES(?,?,?,?,?,?,?,?,?,?)"

#define kInsert_reading_decoding           @"INSERT INTO reading_decoding( \
                                  uid, \
                                  student_middle_sounds, \
                                  student_short_vowels, \
                                  student_long_vowels, \
                                  student_prefixes, \
                                  student_suffixes, \
                                  student_diagraphs, \
                                  student_multisyllabic, \
                                  student_irregular, \
                                  student_blends, \
                                  student_r_controlled) \
                                  VALUES(?,?,?,?,?,?,?,?,?,?,?)"

#define kInsert_reading_fluency            @"INSERT INTO reading_fluency( \
                                 uid, \
                                 student_reads_fluently, \
                                 student_self_monitors, \
                                 student_strategizes_to_read, \
                                 student_inflection, \
                                 student_punctuation, \
                                 student_vocabulary) \
                                 VALUES(?,?,?,?,?,?,?)"

#define kObjects_reading_strategies        @"student_identify_elements, \
                                    student_inferences, \
                                    student_predicts, \
                                    student_sequences, \
                                    student_text_self, \
                                    student_text_text, \
                                    student_text_world, \
                                    student_identify_main, \
                                    student_identify_detail"

#define kObjects_reading_decoding          @"student_middle_sounds, \
                                    student_short_vowels, \
                                    student_long_vowels, \
                                    student_prefixes, \
                                    student_suffixes, \
                                    student_diagraphs, \
                                    student_multisyllabic, \
                                    student_irregular, \
                                    student_blends, \
                                    student_r_controlled"

#define kObjects_reading_fluency           @"student_reads_fluently, \
                                    student_self_monitors, \
                                    student_strategizes_to_read, \
                                    student_inflection, \
                                    student_punctuation, \
                                    student_vocabulary"


// Writing Class Definitions
#define kWriting_Key                       3

#define kTable_writing_formative              @"writing_tests_formative"
#define kTable_writing_standard               @"writing_tests_standard"

#define kTable_writing_mechanics           @"writing_mechanics"
#define kTable_writing_organization        @"writing_organization"
#define kTable_writing_process             @"writing_process"


#define kInsert_writing_mechanics          @"INSERT INTO writing_mechanics ( \
                                    uid,    \
                                    student_capitalizes,   \
                                    student_punctuation,   \
                                    student_subject_verb,  \
                                    student_grammar,   \
                                    student_spells)     \
                                    VALUES (?,?,?,?,?,?)"


#define kObjects_writing_mechanics         @"student_capitalizes,   \
                                    student_punctuation,   \
                                    student_subject_verb,  \
                                    student_grammar,   \
                                    student_spells"

#define kInsert_writing_organization       @"INSERT INTO writing_organization ( \
                                        uid, \
                                        student_hook,  \
                                        student_detail_support, \
                                        student_conclusion, \
                                        student_organizes_paragraphs, \
                                        student_detail_enhance, \
                                        student_transitions, \
                                        student_level) \
                                        VALUES (?,?,?,?,?,?,?,?)"

#define kObjects_writing_organization      @"student_hook,  \
                                        student_detail_support, \
                                        student_conclusion, \
                                        student_organizes_paragraphs, \
                                        student_detail_enhance, \
                                        student_transitions, \
                                        student_level"

#define kInsert_writing_process            @"INSERT INTO writing_process ( \
                                    uid, \
                                    student_planning, \
                                    student_rough_draft, \
                                    student_final, \
                                    student_follows_process) \
                                    VALUES (?,?,?,?,?)"

#define kObjects_writing_process           @"student_planning, \
                                    student_rough_draft, \
                                    student_final, \
                                    student_follows_process"

// Behavioral Class Definitions
#define kBehavioral_Key                    4

#define kTable_behavioral_formative              @"behavioral_tests_formative"
#define kTable_behavioral_standard               @"behavioral_tests_standard"

#define kTable_behavioral_attendance       @"behavioral_attendance"
#define kTable_behavioral_respect          @"behavioral_respect"
#define kTable_behavioral_responsibility   @"behavioral_responsibility"
#define kTable_behavioral_feelings         @"behavioral_feelings"


#define kInsert_behavioral_attendance      @"INSERT INTO behavioral_attendance ( \
                                        uid,    \
                                        student_attentive,  \
                                        student_tardy) \
                                        VALUES (?,?,?)"

#define kInsert_behavioral_respect         @"INSERT INTO behavioral_respect ( \
                                    uid,  \
                                    student_kind,  \
                                    student_respects,  \
                                    student_social) \
                                    VALUES (?,?,?,?)"

#define kInsert_behavioral_responsibility  @"INSERT INTO behavioral_responsibility ( \
                                           uid,  \
                                           student_schoolwork, \
                                           student_homework, \
                                           student_supplies, \
                                           student_follows_directions, \
                                           student_whole_group, \
                                           student_small_group, \
                                           student_independent, \
                                           student_center, \
                                           student_transitions, \
                                           student_initiative) \
                                           VALUES (?,?,?,?,?,?,?,?,?,?,?)"

#define kInsert_behavioral_feelings        @"INSERT INTO behavioral_feelings ( \
                                     uid,  \
                                     student_keeps_to_self, \
                                     student_talks_appropriate, \
                                     student_walks_appropriate, \
                                     student_accepts_responsibility) \
                                     VALUES (?,?,?,?,?)"

#define kObjects_behavioral_attendance     @"student_attentive,  \
                                        student_tardy"

#define kObjects_behavioral_respect        @"student_kind,  \
                                    student_respects,  \
                                    student_social"

#define kObjects_behavioral_responsibility @"student_schoolwork, \
                                            student_homework, \
                                            student_supplies, \
                                            student_follows_directions, \
                                            student_whole_group, \
                                            student_small_group, \
                                            student_independent, \
                                            student_center, \
                                            student_transitions, \
                                            student_initiative"

#define kObjects_behavioral_feelings       @"student_keeps_to_self, \
                                    student_talks_appropriate, \
                                    student_walks_appropriate, \
                                    student_accepts_responsibility"










































































