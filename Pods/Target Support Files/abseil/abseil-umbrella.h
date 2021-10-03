#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "algorithm/algorithm.h"
#import "algorithm/container.h"
#import "base/internal/atomic_hook.h"
#import "base/call_once.h"
#import "base/casts.h"
#import "base/internal/cycleclock.h"
#import "base/internal/low_level_scheduling.h"
#import "base/internal/per_thread_tls.h"
#import "base/internal/spinlock.h"
#import "base/internal/sysinfo.h"
#import "base/internal/thread_identity.h"
#import "base/internal/tsan_mutex_interface.h"
#import "base/internal/unscaledcycleclock.h"
#import "base/internal/hide_ptr.h"
#import "base/internal/identity.h"
#import "base/internal/inline_variable.h"
#import "base/internal/invoke.h"
#import "base/internal/scheduling_mode.h"
#import "base/config.h"
#import "base/options.h"
#import "base/policy_checks.h"
#import "base/attributes.h"
#import "base/const_init.h"
#import "base/internal/thread_annotations.h"
#import "base/macros.h"
#import "base/optimization.h"
#import "base/port.h"
#import "base/thread_annotations.h"
#import "base/dynamic_annotations.h"
#import "base/internal/dynamic_annotations.h"
#import "base/internal/endian.h"
#import "base/internal/unaligned_access.h"
#import "base/internal/errno_saver.h"
#import "base/internal/exponential_biased.h"
#import "base/internal/fast_type_id.h"
#import "base/log_severity.h"
#import "base/internal/direct_mmap.h"
#import "base/internal/low_level_alloc.h"
#import "base/internal/periodic_sampler.h"
#import "base/internal/pretty_function.h"
#import "base/internal/raw_logging.h"
#import "base/internal/spinlock_akaros.inc"
#import "base/internal/spinlock_linux.inc"
#import "base/internal/spinlock_posix.inc"
#import "base/internal/spinlock_wait.h"
#import "base/internal/spinlock_win32.inc"
#import "base/internal/strerror.h"
#import "base/internal/throw_delegate.h"
#import "cleanup/cleanup.h"
#import "cleanup/internal/cleanup.h"
#import "container/btree_map.h"
#import "container/btree_set.h"
#import "container/internal/btree.h"
#import "container/internal/btree_container.h"
#import "container/internal/common.h"
#import "container/internal/compressed_tuple.h"
#import "container/internal/container_memory.h"
#import "container/fixed_array.h"
#import "container/flat_hash_map.h"
#import "container/flat_hash_set.h"
#import "container/internal/hash_function_defaults.h"
#import "container/internal/hash_policy_traits.h"
#import "container/internal/hashtable_debug.h"
#import "container/internal/hashtable_debug_hooks.h"
#import "container/internal/hashtablez_sampler.h"
#import "container/internal/have_sse.h"
#import "container/inlined_vector.h"
#import "container/internal/inlined_vector.h"
#import "container/internal/layout.h"
#import "container/node_hash_map.h"
#import "container/internal/node_hash_policy.h"
#import "container/node_hash_set.h"
#import "container/internal/raw_hash_map.h"
#import "container/internal/raw_hash_set.h"
#import "debugging/internal/address_is_readable.h"
#import "debugging/internal/elf_mem_image.h"
#import "debugging/internal/vdso_support.h"
#import "debugging/internal/demangle.h"
#import "debugging/internal/examine_stack.h"
#import "debugging/failure_signal_handler.h"
#import "debugging/leak_check.h"
#import "debugging/internal/stacktrace_aarch64-inl.inc"
#import "debugging/internal/stacktrace_arm-inl.inc"
#import "debugging/internal/stacktrace_config.h"
#import "debugging/internal/stacktrace_generic-inl.inc"
#import "debugging/internal/stacktrace_powerpc-inl.inc"
#import "debugging/internal/stacktrace_unimplemented-inl.inc"
#import "debugging/internal/stacktrace_win32-inl.inc"
#import "debugging/internal/stacktrace_x86-inl.inc"
#import "debugging/stacktrace.h"
#import "debugging/internal/symbolize.h"
#import "debugging/symbolize.h"
#import "debugging/symbolize_darwin.inc"
#import "debugging/symbolize_elf.inc"
#import "debugging/symbolize_unimplemented.inc"
#import "debugging/symbolize_win32.inc"
#import "flags/commandlineflag.h"
#import "flags/internal/commandlineflag.h"
#import "flags/config.h"
#import "flags/usage_config.h"
#import "flags/declare.h"
#import "flags/flag.h"
#import "flags/internal/flag.h"
#import "flags/internal/sequence_lock.h"
#import "flags/marshalling.h"
#import "flags/internal/parse.h"
#import "flags/parse.h"
#import "flags/internal/path_util.h"
#import "flags/internal/private_handle_accessor.h"
#import "flags/internal/program_name.h"
#import "flags/internal/registry.h"
#import "flags/reflection.h"
#import "flags/usage.h"
#import "flags/internal/usage.h"
#import "functional/bind_front.h"
#import "functional/internal/front_binder.h"
#import "functional/function_ref.h"
#import "functional/internal/function_ref.h"
#import "hash/internal/city.h"
#import "hash/hash.h"
#import "hash/internal/hash.h"
#import "hash/internal/wyhash.h"
#import "memory/memory.h"
#import "meta/type_traits.h"
#import "numeric/bits.h"
#import "numeric/internal/bits.h"
#import "numeric/int128.h"
#import "numeric/int128_have_intrinsic.inc"
#import "numeric/int128_no_intrinsic.inc"
#import "numeric/internal/representation.h"
#import "random/bit_gen_ref.h"
#import "random/bernoulli_distribution.h"
#import "random/beta_distribution.h"
#import "random/discrete_distribution.h"
#import "random/distributions.h"
#import "random/exponential_distribution.h"
#import "random/gaussian_distribution.h"
#import "random/log_uniform_int_distribution.h"
#import "random/poisson_distribution.h"
#import "random/uniform_int_distribution.h"
#import "random/uniform_real_distribution.h"
#import "random/zipf_distribution.h"
#import "random/internal/distribution_caller.h"
#import "random/internal/fast_uniform_bits.h"
#import "random/internal/fastmath.h"
#import "random/internal/generate_real.h"
#import "random/internal/iostream_state_saver.h"
#import "random/internal/mock_helpers.h"
#import "random/internal/nanobenchmark.h"
#import "random/internal/nonsecure_base.h"
#import "random/internal/pcg_engine.h"
#import "random/internal/platform.h"
#import "random/internal/randen_traits.h"
#import "random/internal/pool_urbg.h"
#import "random/internal/randen.h"
#import "random/internal/randen_engine.h"
#import "random/internal/randen_detect.h"
#import "random/internal/randen_hwaes.h"
#import "random/internal/randen_hwaes.h"
#import "random/internal/randen_slow.h"
#import "random/internal/salted_seed_seq.h"
#import "random/internal/seed_material.h"
#import "random/internal/traits.h"
#import "random/internal/uniform_helper.h"
#import "random/internal/wide_multiply.h"
#import "random/random.h"
#import "random/seed_gen_exception.h"
#import "random/seed_sequences.h"
#import "status/internal/status_internal.h"
#import "status/status.h"
#import "status/status_payload_printer.h"
#import "status/internal/statusor_internal.h"
#import "status/statusor.h"
#import "strings/cord.h"
#import "strings/internal/cord_internal.h"
#import "strings/internal/cord_rep_flat.h"
#import "strings/internal/cord_rep_ring.h"
#import "strings/internal/cord_rep_ring_reader.h"
#import "strings/internal/char_map.h"
#import "strings/internal/escaping.h"
#import "strings/internal/ostringstream.h"
#import "strings/internal/resize_uninitialized.h"
#import "strings/internal/utf8.h"
#import "strings/str_format.h"
#import "strings/internal/str_format/arg.h"
#import "strings/internal/str_format/bind.h"
#import "strings/internal/str_format/checker.h"
#import "strings/internal/str_format/extension.h"
#import "strings/internal/str_format/float_conversion.h"
#import "strings/internal/str_format/output.h"
#import "strings/internal/str_format/parser.h"
#import "strings/ascii.h"
#import "strings/charconv.h"
#import "strings/escaping.h"
#import "strings/internal/charconv_bigint.h"
#import "strings/internal/charconv_parse.h"
#import "strings/internal/memutil.h"
#import "strings/internal/stl_type_traits.h"
#import "strings/internal/str_join_internal.h"
#import "strings/internal/str_split_internal.h"
#import "strings/internal/string_constant.h"
#import "strings/match.h"
#import "strings/numbers.h"
#import "strings/str_cat.h"
#import "strings/str_join.h"
#import "strings/str_replace.h"
#import "strings/str_split.h"
#import "strings/string_view.h"
#import "strings/strip.h"
#import "strings/substitute.h"
#import "synchronization/internal/graphcycles.h"
#import "synchronization/internal/kernel_timeout.h"
#import "synchronization/barrier.h"
#import "synchronization/blocking_counter.h"
#import "synchronization/internal/create_thread_identity.h"
#import "synchronization/internal/futex.h"
#import "synchronization/internal/per_thread_sem.h"
#import "synchronization/internal/waiter.h"
#import "synchronization/mutex.h"
#import "synchronization/notification.h"
#import "time/internal/cctz/include/cctz/civil_time.h"
#import "time/internal/cctz/include/cctz/civil_time_detail.h"
#import "time/internal/cctz/include/cctz/time_zone.h"
#import "time/internal/cctz/include/cctz/zone_info_source.h"
#import "time/internal/cctz/src/time_zone_fixed.h"
#import "time/internal/cctz/src/time_zone_if.h"
#import "time/internal/cctz/src/time_zone_impl.h"
#import "time/internal/cctz/src/time_zone_info.h"
#import "time/internal/cctz/src/time_zone_libc.h"
#import "time/internal/cctz/src/time_zone_posix.h"
#import "time/internal/cctz/src/tzfile.h"
#import "time/civil_time.h"
#import "time/clock.h"
#import "time/internal/get_current_time_chrono.inc"
#import "time/internal/get_current_time_posix.inc"
#import "time/time.h"
#import "types/any.h"
#import "types/bad_any_cast.h"
#import "types/bad_any_cast.h"
#import "types/bad_optional_access.h"
#import "types/bad_variant_access.h"
#import "types/compare.h"
#import "types/internal/optional.h"
#import "types/optional.h"
#import "types/internal/span.h"
#import "types/span.h"
#import "types/internal/variant.h"
#import "types/variant.h"
#import "utility/utility.h"

FOUNDATION_EXPORT double abslVersionNumber;
FOUNDATION_EXPORT const unsigned char abslVersionString[];

