# Script & Author Information -----------------------------------------
# script to generate trial lists for the flanker switch task
# Author: Marcus Möschl
# Affiliation: Department of Psychology, TU Dresden, Germany
# Contact: marcus.moeschl@tu-dresden.de



# Description -------------------------------------------------------------

# generate 16 lists of trial transitions (65 trials)
# 2 or 4 can be used as baseline and 4 per shielding/shifting condition
# goal is to have each list contain an equal number of:
# stimulus transitions and congruency transitions from trial n-1 to n
# in this case, we use letters S and H for a letter task and colors red and blue
# for a color task
# The script generales trial lists with 64 transitions each from a matrix that contains
# each possible transition/combination of two trials within each type of stimulus/task transition.
# Note that this controls only for the congruency of the target and flanker stimuli in the
# task-relevant stimulus dimension.
# That is, for letters only letters and for
# colors only colors.
# Stimulus congruency is determined by the stimulus-response mapping:
# "s" and "red" map to a "left" response
# "h" and "blue" map to a "right" response
# Although stimuli appear in each combination of target and flanker congruency
# in the task-relevant and task-irrelevant stimulus dimensions,
# the script does not balance transitions between congruencies in the
# the task-irrelevant stimulus dimension




# Prepare Environment -----------------------------------------------------

# clear workspace if needed
# rm(list = ls())

# set working directory
setwd("~/Desktop/FlankerSwitchTask/script_pickCond_findStarts/")


# set path to store trial lists
# path_to_lists_complete <- "trial_lists/complete/"
# path_to_lists_incomplete <- "trial_lists/incomplete/"

path_to_lists_complete <- "lists_pickCond_findStarts/"
path_to_lists_incomplete <- "lists_pickCond_findStarts/"
path_to_output <- "output_pickCond_findStarts/"

# Prepare List Generation -------------------------------------------------

# get transition template and list check function
source("tr_arr_flankerSwitch_MM_201102.R")
source("list_check_function_MM_201031_updated_findStarts.R")

# copy original list of trial transitions list to use list generation
tr_list_orig <- as.matrix(tr_list)
# View(tr_list_orig)


# empty transition list for list generation (64 transitions)
tr_gen_list_null <- matrix(nrow = 64, ncol = 24)
colnames(tr_gen_list_null) <- c(colnames(tr_list_orig), "seed_num", "list_num", "run_count_list", "trial_num", "subject", "tr_fit")

# empty list that will be filled with transition lists generated in the loop
transition_lists_comp_null <- matrix(nrow = 1024, ncol = 24)
colnames(transition_lists_comp_null) <- c(colnames(tr_list_orig), "seed_num", "list_num", "run_count_list", "trial_num", "subject", "tr_fit")




# # (optional) continue with previous lists ---------------------------------
# old_tr_list <- as.matrix(read.csv2("./trial_lists/incomplete/tr_for_list_15to16_999_seed_454541_incompl.csv"))
# prev_list <- old_tr_list
# count_prev_list <- 15
# View(prev_list)
# table(prev_list[, 3][prev_list[, 3] != 0],
#       prev_list[, 5][prev_list[, 3] != 0])



# List Generation --------------------------------------------------------

# sink()
# # record console output
# sink(paste("./gen_output_nr_", 999, "_seed_", 454541, ".txt", sep = ""), append = TRUE)
#
# for (subject_count in c(1:100)) {
for (subject_count in c(1:24)) {

  # set seed to reproduce results
  seed_num <- round(runif(1, 0, 1) * 1000000, 0)
  # seed_num <- 997285
  set.seed(seed_num)

   sink(paste(path_to_output, "NEW_gen_output_nr_", subject_count, "_seed_", seed_num, ".txt", sep = ""), append = TRUE)


  # initialize variables/lists per subject
  tansition_lists_per_seed <- list()
  transition_lists_comp <- transition_lists_comp_null
  tr_avail_current <- list()
  list_count <- 1
  run_count <- 0
  run_count_list <- 0
  list_save_count <- 0
  remainder_fail_count <- 0
  run_abort <- FALSE
  check_fail_remainder <- FALSE
  done <- FALSE

  # use to continue with old list
  # list_count <- count_prev_list

  #
  # # determine tr_cond_num for start transitions of each list
  # # there are 16 tr_cond_num and 16 lists to be made
  # # then pick start element from condition ...
  # tr_cond_num_lists <- sample(1:16, 16)
  # sample(1:16, 16)
  #
  #


  # run loop until 16 lists are created per subject
  repeat {
    # initialize lists that will be used for list generation
    tr_gen_current <- tr_gen_list_null    # stores selected transitions for current list
    tr_list_temp <- list()    # stores remaining transitions  (will be modified)
    tr_list_target <- list()   # stores transitions that start with trial_n of the previous transition in tr_gen_current

    # increment run counts
    run_count <- run_count + 1      # number of times this repeat ran until next subject
    run_count_list <- run_count_list + 1 # number of times this repeat ran until next list

    # start first run with the complete transition list (tr_list_orig)
    if (run_count == 1) {
      list_count <- 1
      tr_avail_current <- tr_list_orig  # set list of currently available transitions to original list
      tr_list_backup_run <- tr_list_orig  # not sure if needed: store original list as backup
      run_abort <- FALSE  # not sure if needed
    }

    # # use when continuing with old lists...
    # if (run_count == 1 & list_count == count_prev_list) {
    #   tr_avail_current <- prev_list  # set list of currently available transitions to original list
    #   tr_list_backup_run <- prev_list  # not sure if needed: store original list as backup
    #   run_abort <- FALSE  # not sure if needed
    #   print("first run old list")
    # }

   # print(paste("START list abort", run_abort))

    # check if previous list_run failed, if yes: start again with available transitions from previous run (the backup list)
    if (run_abort == TRUE ) {
      # print("NEUSTART weil Rest nicht geht mit Liste")
      tr_avail_current <- tr_list_backup_run
    }

    # copy the list of currently available transitions at the start of a run (will be modified until list run was succesful)
    tr_list_temp <- tr_avail_current


#     #### GET OUTPUT
#     print(paste("subject", subject_count,
#                 "list_count", list_count,
#                 "run_count", run_count,
#                 "run_count_list", run_count_list,
#                 "length current list begin", NROW(tr_list_temp),
#                 "seed", seed_num,
#                 "remainder_fail_count", remainder_fail_count)
#           )
#




    # # LIST CHECK::::
    # transitions_to_check <- tr_list_temp
    # n_remaining_lists <- 16 - (list_count)
    # # this is the function that is sourced at the beginning of the script (returns TRUE/FALSE for whether the check failed)
    # check_fail_remainder <-
    #   fn_check_list_properties(tr_list_to_check = transitions_to_check,
    #                            n_lists_to_check = n_remaining_lists )


    # muss die functions hier noch anpassen!!!!???? Nein. die sind okay. Das läuft so.
    # wenn ich für die letzten Blöcke noch ein Kriterium lachser mache, geht das mit dem prüfen. Dann kann ich aber nicht mehr diese ganze checking Routine nutzen


  ##########CHANGES MADE HERE!!!!! TO PICK STARTING ELEMENTS--------
    # checks for potential start items in tr_list_temp
    # tr_num moved from [, 4] to [, 18]

    freq_lag1_in_n_TRUE <- table(tr_list_temp[, 1] %in% tr_list_temp[, 2])["TRUE"]
    freq_n_in_lag1_TRUE <- table(tr_list_temp[, 2] %in% tr_list_temp[, 1])["TRUE"]

    freq_lag1_in_n_FALSE <- (16 - (list_count) + 1) * 64 - freq_lag1_in_n_TRUE
    freq_n_in_lag1_FALSE <- (16 - (list_count) + 1) * 64 - freq_n_in_lag1_TRUE

    #### checke overlap. wenn okay, checke frequency
    if (freq_lag1_in_n_FALSE <= (16 - (list_count) + 1) |
        freq_n_in_lag1_FALSE <= (16 - (list_count) + 1) ) {

      # get frequency of items in overlap
      tr_list_overlap <- tr_list_temp[(tr_list_temp[, 1] %in% tr_list_temp[, 2]) & (tr_list_temp[, 2] %in% tr_list_temp[, 1]), , drop = FALSE ]
      freq_trials_lag1_overlap <- table(tr_list_overlap[, 1])
      freq_trials_n_overlap <- table(tr_list_overlap[, 2])

      # get table of frequency differences
      tab_diff_freq_lag1_n <- freq_trials_lag1_overlap - freq_trials_n_overlap
      # if negative difference: fewer items in lag 1 than in n
      # if positive difference: more items in lag 1 than in n
      freq_fewer_items_lag1_n <- length(tab_diff_freq_lag1_n[tab_diff_freq_lag1_n < 0])
      # freq_fewer_items_n_lag1 <- length(tab_diff_freq_lag1_n[tab_diff_freq_lag1_n > 0])


      # potential start items. For the list generation: pick randomly from these?
      # aber nur, wenn es Unterschiede gibt. Ansonsten kann es auch sein, dass alle gleich sind?
      if (freq_fewer_items_lag1_n > 0) {



        pot_tr_start_rnd <- tr_list_temp[tr_list_temp[, 1] %in% names(tab_diff_freq_lag1_n[tab_diff_freq_lag1_n == -1]), ]
        tr_start_rnd <- sample(tr_list_temp[, 18], 1)
        tr_start <- tr_list_temp[tr_list_temp[, 18] == tr_start_rnd, 1:2]



      } else {

      # pick random start element from tr_num in currently available transition list (tr_list_temp)
      tr_start_rnd <- sample(tr_list_temp[, 18], 1)
      tr_start <- tr_list_temp[tr_list_temp[, 18] == tr_start_rnd, 1:2]
    }
    }





# changed array positions:
    colnames(tr_list_temp)

    # add selected transitions & add info (drop = FALSE is needed to prevent R dropping dimensions and turning the matrix to a numeric if only 1 item or 0 items are in it)
    tr_gen_current[1, 1:18] <- tr_list_temp[tr_list_temp[, 18] == tr_start_rnd, 1:18 , drop = FALSE]
    tr_gen_current[, 19][1] <- seed_num
    tr_gen_current[, 20][1] <- list_count
    tr_gen_current[, 21][1] <- run_count_list
    tr_gen_current[, 22][1] <- 1
    tr_gen_current[, 23][1] <- subject_count

    # remove the starting transition from the list of remaining transitions
    tr_list_temp <- tr_list_temp[tr_list_temp[, 18] != tr_start_rnd, , drop = FALSE]

    # print(NROW(tr_list_temp))

    # now start loop to pick the remaining transitions for the list
    # get list of all transitions that start with trial_n in the current transition
    # if a transition fits, remove it from the transition lists (avoid double sampling)
    for (i in c(2:64)) {
      tr_current <- tr_gen_current[i - 1, 1:2]  # current transition, for which we are searching a next trial
      tr_list_target <- tr_list_temp[tr_list_temp[, 1] == tr_current[2], , drop = FALSE] # get remaining transitions that start with trial_n of the current transition

      # pick random transition from tr_list_target until each cell in table(cond_num, fl_congr_dim_rel_num) == 1
      # ensures an equal number of congruency/stimulus transitions in each list of 64 transitions.
      repeat {
        # if tr_list_target empty: abort and start over (nothing to pick from)
        if (NROW(tr_list_target) == 0) { # not sure if needed here
          run_abort <- TRUE
          break
        } else {
          # If tr_list_target not empty: pick random transition from tr_list_target
          tr_next_rnd <- sample(1:NROW(tr_list_target), 1)
          tr_num_next <- tr_list_target[, 18][tr_next_rnd]
          tr_next <- tr_list_target[tr_list_target[, 18] == tr_num_next, 1:2]
        }

        # add selected transitions & add info
        tr_gen_current[i, 1:18] <- tr_list_target[tr_list_target[, 18] == tr_num_next, 1:18 , drop = FALSE]
        tr_gen_current[, 19][i] <- seed_num
        tr_gen_current[, 20][i] <- list_count
        tr_gen_current[, 21][i] <- run_count_list
        tr_gen_current[, 22][i] <- 1
        tr_gen_current[, 23][i] <- subject_count

#
#         # head(tr_gen_current)
#         # if I only check this... then the CC, CI, IC II can be from the same
#         # get number of transitions per cell (remove cells with cond_num == 0 during list generation)
#         tr_tbl_current <- table(
#           tr_gen_current[, 3][tr_gen_current[, 3] != 0],
#           tr_gen_current[, 17][tr_gen_current[, 3] != 0]
#         )

#### CHANGES MADE HERE!!!! table of transition types ----
        # goal: list should contain each transition of congruency (CC, CI, IC, II) for each transition of task and stimuli (1...16)
        # get number of transitions of task and stimuli per congruency  (remove cells with cond_num == 0 during list generation)
        # this should be filled with 1 per cell and
        tr_tbl_cond_stim_current <- table(
          tr_gen_current[, 3][tr_gen_current[, 3] != 0],
          tr_gen_current[, 17][tr_gen_current[, 3] != 0]
        )

        # get number of transitions of task and stimuli and congruency  (remove cells with cond_num == 0 during list generation)
        # this should be filled with 1 per cell
        tr_tbl_cond_stim_congr_current <- table(
          tr_gen_current[, 4][tr_gen_current[, 4] != 0]
        )


        # check if transitions distributed evenly (max. 1 per cell). if yes: go on (i.e., go outside the repeat)
        # if (all(tr_tbl_current < 2)) {
        if (all(tr_tbl_cond_stim_current < 2) & all(tr_tbl_cond_stim_congr_current < 2) ) {
          tr_list_temp <- tr_list_temp[tr_list_temp[, 18] != tr_num_next, , drop = FALSE]
          run_abort <- FALSE
          # print("trial okay after congruency check")
          break
        } else {
          # if no: remove the transitions picked so far from tr_list_target and start over (no double picking) with new tr_list_target
          tr_list_target <- tr_list_target[tr_list_target[, 18] != tr_num_next, , drop = FALSE]
          # if tr_list_target is empty, abort and start over (i.e., go outside the repeat)
          if (NROW(tr_list_target) == 0) {
            run_abort <- TRUE
            # print(paste("END remaining targets", NROW(tr_list_target), "run", run_count, "ABORT"))
            break
          }
        }
      }

      # stop looking for trials and start a new run for the list if list abort is true,
      # otherwise continue to check properties of the list
      if (run_abort == TRUE) {
        # print(paste("END outside repeat -  remaining targets", nrow(tr_list_target)))
        # print(paste("run", run_count, "ABORT"))
        break
      }
    }

    # print("after congruency check (for loop for list)...should check rest of list now")
    # print(paste("run_abort", run_abort, "at list", list_count))

    # if list was created, check whether lists can be created from remaining transitions up to list 16 (at list 15, this also implicitly checks for list 16)
    if (run_abort == FALSE) {
      if (list_count < 16) {
        # print("current list is okay, now check remaining items")

        #### GET OUTPUT
        print(paste(
          "List" , list_count, "created, check remaining transitions",
          "subject", subject_count,
          "list_count", list_count,
          "run_count", run_count,
          "run_count_list", run_count_list,
          "length current list begin", NROW(tr_list_temp),
          "seed", seed_num,
          "remainder_fail_count", remainder_fail_count)
        )

        # LIST CHECK::::
        transitions_to_check <- tr_list_temp
        n_remaining_lists <- 16 - (list_count)
       # this is the function that is sourced at the beginning of the script (returns TRUE/FALSE for whether the check failed)
        check_fail_remainder <-
          fn_check_list_properties(tr_list_to_check = transitions_to_check,
                                   n_lists_to_check = n_remaining_lists )
        if (check_fail_remainder == TRUE) {

          remainder_fail_count <- remainder_fail_count + 1  # track how often this failed
          print(paste("rest of the items failed, count", remainder_fail_count))
          # remainder_list <- tr_list_temp # save remaining items
          next # jump to next run for the list (break would jump to next subject)
        } else if (check_fail_remainder == FALSE) { # not needed
          print(paste("liste nr.",  list_count, "gemacht, rest okay...nächste Liste"))
          # remainder_list <- tr_list_temp # save remaining items

          print(paste(
            "List" , list_count, "created, remaining transitions okay!",
            "subject", subject_count,
            "list_count", list_count,
            "run_count", run_count,
            "run_count_list", run_count_list,
            "length current list begin", NROW(tr_list_temp),
            "seed", seed_num,
            "remainder_fail_count", remainder_fail_count)
          )

        }
      }

      # if both are fine, go on and store the list
      tr_list_backup_run <- tr_list_temp # store current tr_list_temp as a fallback in case generating the next list fails
      tr_avail_current <- tr_list_temp # update list of now available transitions for the next list run (remove used transitions)
      tansition_lists_per_seed[[list_count]] <- tr_gen_current  # add trial and transition info to subject list (this is not saved anywhere)

      # add generated transition list to overall list of transitions that will be used for the experiment
      tr_list_lim <- c(1, 65, 129, 193, 257, 321, 385, 449, 513, 577, 641, 705, 769, 833, 897, 961) # where to start writing info
      transition_lists_comp[tr_list_lim[list_count]:(tr_list_lim[list_count] + 63), ] <- tr_gen_current
      # print(paste("END list count success", list_count))

      # reset run_count_list for next list and increment list_count
      run_count_prev <- run_count_list
      run_count_list <- 0
      list_count <- list_count + 1
      # print(paste("seed", seed_num, "list", list_count - 1, "run", run_count))
      run_abort <-  FALSE  # not sure if needed
    }

    # save transition list in csv and advance to the next subject (starts at 13 lists)
    # list_names_incomplete <- c("14to16", "15to16", "16") # could be done outside the loop
    # if (list_save_count == 0 & list_count == 1 + 13) {
    #   list_save_count <- 1
    #   complete_list <- na.omit(transition_lists_comp)
    #   incomplete_list <- cbind(tr_list_backup_run, "seed" = seed_num, "run_count" = run_count)
    #   write.csv2(complete_list,  paste(path_to_lists_complete, "pickCond_tr_lists_to_", list_count - 1, "_nr_",
    #                                    subject_count, "_seed_", seed_num, ".csv", sep = ""), row.names = FALSE)
    #   write.csv2(incomplete_list, paste(path_to_lists_incomplete, "pickCond_tr_for_list_",
    #                                     list_names_incomplete[list_save_count], "_",  subject_count, "_seed_",
    #                                     seed_num, "_incompl.csv", sep = ""), row.names = FALSE)
    #   print(paste("incomplete lists saved.", "seed", seed_num, "list",  list_names_incomplete[list_save_count] , "run", run_count))
    # } else if (list_save_count == 1 & list_count == 1 + 14) {
    #   list_save_count <- 2
    #   complete_list <- na.omit(transition_lists_comp)
    #   incomplete_list <- cbind(tr_list_backup_run, "seed" = seed_num, "run_count" = run_count)
    #   write.csv2(complete_list,  paste(path_to_lists_complete, "pickCond_tr_lists_to_", list_count - 1, "_nr_",
    #                                    subject_count, "_seed_", seed_num, ".csv", sep = ""), row.names = FALSE)
    #   write.csv2(incomplete_list, paste(path_to_lists_incomplete, "pickCond_tr_for_list_",
    #                                     list_names_incomplete[list_save_count], "_", subject_count, "_seed_",
    #                                     seed_num, "_incompl.csv", sep = ""), row.names = FALSE)
    #   print(paste("incomplete lists saved.", "seed", seed_num, "list",  list_names_incomplete[list_save_count] , "run", run_count))
    # } else if (list_save_count == 2 & list_count == 1 + 15) {
    #   list_save_count <- 3
    #   complete_list <- na.omit(transition_lists_comp)
    #   incomplete_list <- cbind(tr_list_backup_run, "seed" = seed_num, "run_count" = run_count)
    #   write.csv2(complete_list,  paste(path_to_lists_complete, "pickCond_tr_lists_to_", list_count -1, "_nr_",
    #                                    subject_count, "_seed_", seed_num, ".csv", sep = ""), row.names = FALSE)
    #   write.csv2(incomplete_list, paste(path_to_lists_incomplete, "pickCond_tr_for_list_",
    #                                     list_names_incomplete[list_save_count], "_", subject_count, "_seed_",
    #                                     seed_num, "_incompl.csv", sep = ""), row.names = FALSE)
    #   print(paste("incomplete lists saved.", "seed", seed_num, "list",  list_names_incomplete[list_save_count] , "run", run_count))
    # } else if (list_save_count == 3 & list_count == 1 + 16) {
    if (list_save_count == 0 & list_count == 1 + 16) {
      list_save_count <- 4
      print(paste("YAY, COMPLETE!!!", "seed", seed_num, "list", list_count - 1, "run", run_count))
      complete_list <- na.omit(transition_lists_comp)
      write.csv2(complete_list,  paste(path_to_lists_complete, "NEWcheck_tr_lists_complete", "_nr_",
                                                 subject_count, "_seed_", seed_num, ".csv", sep = ""), row.names = FALSE)
      # print(paste("incomplete", "seed", seed_num, "list", list_count - 1, "run", run_count))
      # go on to next subject
      # break # subject_count <- subject_count + 1 is not needed in for loop
      # done <- TRUE
    }
    if (list_count > 16) {
      print("16 Lists done, Move on")
      # sink()
      break # to next subject
    }
    # if (list_count > 1) {
    #   print(paste(list_count-1, "Lists done, Move on"))
    #   # sink()
    #   # testlist <- tr_gen_current
    #   testlist <- na.omit(transition_lists_comp)
    #
    #   break # to next subject
    # }
  }
}

test_task_stim <- testlist
test_task_stim_congr <- testlist

View(test_task_stim_congr)
table(test_task_stim_congr[, "cond_tr_task_stim_congr"])
table(test_task_stim_congr[, "cond_tr_task_stim"])

View(test_task_stim)
table(test_task_stim[, "cond_tr_task_stim_congr"])
table(test_task_stim[, "cond_tr_task_stim"])


colnames(testlist)
 View(test_task_stim)

 run_count

# sink()


# Manually check list properties -------------------------------------

# View(transition_lists_comp)
# table(transition_lists_comp[, 14])
# table(transition_lists_comp[, 3], transition_lists_comp[, 5], transition_lists_comp[, 13], dnn = c("cond_num", "fl_congr", "list") )
# View(tansition_lists_per_seed )
# View(tr_gen_current)
